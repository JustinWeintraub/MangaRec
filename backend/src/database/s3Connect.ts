import { createRequire } from "module";
const require = createRequire(import.meta.url);
//var AWS = require("aws-sdk");
import AWS from "aws-sdk";
AWS.config.getCredentials(function (err) {
  if (err) console.log(err.stack);
  // credentials not loaded
});

const s3 = new AWS.S3();

const fetch = require("node-fetch");
//const file = fs.readFileSync(path.resolve(__dirname, "../file.xml"));

export const getImageFromId = async (bucket: string, id: string) => {
  const params = {
    Bucket: bucket,
    Key: id,
  };
  try {
    const data = await s3.getObject(params).promise();

    const response = {
      body: JSON.stringify(data),
    };
    return response;
  } catch (e) {
    return null;
  }
};
export const uploadFile = (fileContent, key) => {
  // Read content from the file
  // takes in blob or string

  // Setting up S3 upload parameters
  const params = {
    Bucket: "mangarec-bucket",
    Key: key + ".jpg", // File name you want to save as in S3
    Body: fileContent,
  };
  // Uploading files to the bucket
  s3.upload(params, function (err, data) {
    if (err) {
      throw err;
    }
    console.log(`File uploaded successfully. ${data.Location}`);
  });
};

export const uploadImageFromUrl = (url, key) => {
  fetch("https://" + url)
    .then((res) => res.blob()) // Gets the response and returns it as a blob
    .then((blob) => uploadBufferFromBlob(blob, key));
};

export const uploadBufferFromBlob = (blob, key) => {
  try {
    blob.arrayBuffer().then((ab) => {
      // converting to buffer
      const buffer = Buffer.alloc(ab.byteLength);
      const view = new Uint8Array(ab);
      for (var i = 0; i < buffer.length; ++i) {
        buffer[i] = view[i];
      }
      uploadFile(buffer, key);
    });
  } catch {
    throw new Error("buffer creation failed for " + key);
  }
};

// TODO write jest for this
