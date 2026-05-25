/**
 * Cole este script no DevTools (Console) estando logado na lição:
 * https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906405
 *
 * O script baixa a transcrição como .vtt e .txt no navegador.
 */
(async function extractTechLeadsTranscript() {
  const pathMatch = window.location.pathname.match(
    /\/c\/([^/]+)\/sections\/(\d+)\/lessons\/(\d+)/
  );

  if (!pathMatch) {
    throw new Error(
      "Abra a página da lição do curso (logado) antes de executar este script."
    );
  }

  const [, spaceSlug, sectionId, lessonId] = pathMatch;
  const csrf =
    document.querySelector('meta[name="csrf-token"]')?.content || "";

  const headers = {
    Accept: "application/json",
    "X-Requested-With": "XMLHttpRequest",
    ...(csrf ? { "X-CSRF-Token": csrf } : {}),
  };

  async function apiFetch(path) {
    const response = await fetch(`/internal_api/${path.replace(/^\//, "")}`, {
      headers,
      credentials: "include",
    });

    if (!response.ok) {
      throw new Error(`${path} -> HTTP ${response.status}`);
    }

    return response.json();
  }

  function parseVtt(vtt) {
    return vtt
      .split("\n")
      .filter((line) => {
        const trimmed = line.trim();
        return (
          trimmed &&
          !trimmed.startsWith("WEBVTT") &&
          !/^\d+$/.test(trimmed) &&
          !/^\d{2}:\d{2}:\d{2}\.\d{3}\s-->/.test(trimmed)
        );
      })
      .join("\n")
      .replace(/\n{3,}/g, "\n\n")
      .trim();
  }

  function download(filename, content, mime = "text/plain;charset=utf-8") {
    const blob = new Blob([content], { type: mime });
    const anchor = document.createElement("a");
    anchor.href = URL.createObjectURL(blob);
    anchor.download = filename;
    anchor.click();
    URL.revokeObjectURL(anchor.href);
  }

  function findTranscriptId(source, depth = 0) {
    if (!source || depth > 8) return null;

    if (typeof source === "object") {
      for (const [key, value] of Object.entries(source)) {
        if (/transcript/i.test(key) && typeof value === "number") {
          return value;
        }
        if (/transcript/i.test(key) && value && typeof value === "object" && value.id) {
          return value.id;
        }
        const nested = findTranscriptId(value, depth + 1);
        if (nested) return nested;
      }
    }

    return null;
  }

  let courseId = null;
  let lesson = null;
  let transcriptId = null;

  try {
    const space = await apiFetch(`spaces/${spaceSlug}`);
    courseId =
      space?.course?.id ||
      space?.course_id ||
      space?.linked_course_id ||
      space?.space?.course_id ||
      null;
  } catch (error) {
    console.warn("Não foi possível obter courseId via spaces API:", error.message);
  }

  const root = document.getElementById("react-root");
  if (!courseId && root?.dataset?.props) {
    try {
      const props = JSON.parse(root.dataset.props);
      courseId =
        props?.course?.id ||
        props?.lesson?.course_id ||
        findTranscriptId(props) ||
        null;
    } catch {
      /* ignore */
    }
  }

  if (courseId) {
    lesson = await apiFetch(
      `courses/${courseId}/sections/${sectionId}/lessons/${lessonId}`
    );
    transcriptId = findTranscriptId(lesson);
  }

  if (!transcriptId) {
    const domText = Array.from(
      document.querySelectorAll('[class*="transcript" i], [data-testid*="transcript" i]')
    )
      .map((node) => node.textContent?.trim())
      .filter(Boolean)
      .join("\n\n");

    if (domText.length > 100) {
      download(`transcricao-lesson-${lessonId}.txt`, domText);
      console.log("Transcrição extraída do DOM.");
      return domText;
    }

    throw new Error(
      "Não encontrei media_transcript_id. Verifique se a transcrição está habilitada nesta lição."
    );
  }

  const vttResponse = await fetch(`/media_transcripts/${transcriptId}.vtt`, {
    credentials: "include",
  });

  if (!vttResponse.ok) {
    const json = await apiFetch(`media_transcripts/${transcriptId}`);
    const text =
      json?.text ||
      json?.content ||
      JSON.stringify(json, null, 2);
    download(`transcricao-lesson-${lessonId}.txt`, text);
    console.log("Transcrição salva via JSON da API.");
    return text;
  }

  const vtt = await vttResponse.text();
  const text = parseVtt(vtt);

  download(`transcricao-lesson-${lessonId}.vtt`, vtt, "text/vtt;charset=utf-8");
  download(`transcricao-lesson-${lessonId}.txt`, text);

  console.log("Transcrição baixada com sucesso.");
  console.log({ spaceSlug, sectionId, lessonId, courseId, transcriptId });
  return text;
})();
