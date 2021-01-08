import api from "mangadex-full-api";

const timer = (ms) => new Promise((res) => setTimeout(res, ms));

// gets mangas based off of tags/the genre they're in, scraping from mangarec
export async function getMangaFromTags(tags) {
  return await api.agent
    .login(process.env["USERNAME"], process.env["PASSWORD"], false)
    .then(async () => {
      const scrapeRes = {};
      for (const data of tags) {
        await timer(3000);
        const { tag, amount } = data;
        try {
          const res = await api.Manga.fullSearch({
            includeTags: [tag],
            excludeTags: [9, 49, 50, 32],
            order: 9,
          });
          res
            .slice(0, amount)
            .forEach((manga) => (scrapeRes[manga.id] = manga));
          console.log("Done!");
        } catch (e) {
          console.log(e);
        }
      }

      console.log("We good.");
      // filtering
      const filteredRes = Object.keys(scrapeRes).reduce(function (
        filtered,
        key
      ) {
        if (scrapeRes[key].title.slice(0, 2) != "\r\n")
          filtered[key] = scrapeRes[key];
        return filtered;
      },
      {});
      return filteredRes;
    });
}

// gets all the manga data for a specific title
export async function getAllMangaData(name: string) {
  try {
    const manga = new api.Manga();
    const mangaData = await manga.fillByQuery(name);
    const mangaAttrs: any = (({
      id,
      cover,
      title,
      genres,
      language,
      authors,
      description,
      rating,
      views,
      url,
    }) => ({
      id,
      cover,
      title,
      genres,
      language,
      authors,
      description,
      rating,
      views,
      url,
    }))(mangaData);
    console.log("Got attributes");
    return mangaAttrs;
  } catch (e) {
    console.log(e);
    throw new Error(`Manga ${name} doesn't exist!`);
  }
}

export async function login() {
  return await api.agent.login(
    process.env.USERNAME,
    process.env.PASSWORD,
    false
  );
}
