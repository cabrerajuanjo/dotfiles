// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

// module.exports = {
//   defaultBrowser: "Safari",
//   handlers: [
//     {
//       // Open google.com and *.google.com urls in Google Chrome
//       match: /^(https?:\/\/)?gitlab\.com.*$/,
//       // match: ({ url }) => url.host === "gitlab.com",
//       // match: /.*/,
//       browser: {
//         name: "Mozilla Firefox",
//         profile: "Default",
//       },
//     },
//     {
//       match: /^(https?:\/\/)?work\.atlassian\.net.*$/,
//       // match: ({ url }) => url.host === "gitlab.com",
//       // match: /.*/,
//       browser: {
//         name: "Google Chrome",
//         profile: "Profile 3",
//       },
//     },
//   ],
// };
module.exports = {
    defaultBrowser: "Google Chrome",
    handlers: [
        {
            match: /^https:\/\/gitlab.*$/,
            browser: "Google Chrome",
        },
        {
            match: /^https?:\/\/work\.atlassian\.net\/.*$/,
            browser: "Google Chrome",
        },
        {
            match: /^https:\/\/device\.sso\.us\-east\-1\.amazonaws\.com\/$/,
            browser: "Google Chrome",
        },
        {
            match: /^https:\/\/statics\.teams\.cdn\.office\.net\/.*$/,
            browser: "Google Chrome",
        },
    ],
};
