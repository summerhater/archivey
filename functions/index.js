const { onRequest } = require("firebase-functions/v2/https");
const cors = require("cors")({ origin: true });
const axios = require("axios"); // npm install axios 필요

exports.proxy = onRequest(async (req, res) => {
  cors(req, res, async () => {
    // URL에서 대상 주소 가져오기 (예: ?url=https://...)
    const targetUrl = req.query.url;

    if (!targetUrl) {
      return res.status(400).send("Missing 'url' parameter");
    }

    try {
      const response = await axios.get(targetUrl, {
        responseType: 'arraybuffer' // 이미지 데이터를 그대로 가져오기 위해
      });

      // 원래 이미지의 콘텐츠 타입을 그대로 전달
      res.set("Content-Type", response.headers["content-type"]);
      res.send(response.data);
    } catch (error) {
      res.status(500).send("Error fetching image: " + error.message);
    }
  });
});