const path = require("path");
const glob = require("glob");
const HardSourceWebpackPlugin = require("hard-source-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const { InjectManifest } = require("workbox-webpack-plugin");

module.exports = (env, options) => {
  const devMode = options.mode !== "production";

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
        new OptimizeCSSAssetsPlugin({}),
      ],
    },
    entry: {
      app: glob.sync("./vendor/**/*.js").concat(["./js/app.js"]),
      pyworker: ["./js/pyworker.js"],
      processing_worker: ["./js/processing_worker.js"],
      // 'sw': ['./js/sw.js']
    },
    output: {
      filename: "[name].js",
      path: path.resolve(__dirname, "../priv/static/js"),
      publicPath: "/js/",
    },
    devtool: devMode ? "eval-cheap-module-source-map" : undefined,
    module: {
      rules: [
        {
          test: /worker\.js$/,
          use: { loader: "worker-loader" },
        },
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
            options: {
              targets: "defaults",
              presets: ["@babel/preset-env", "@babel/preset-typescript"],
              plugins: [
                "@babel/plugin-proposal-class-properties",
                "@babel/plugin-syntax-import-meta",
              ],
            },
          },
        },
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, "css-loader", "postcss-loader"],
        },
        {
          test: /\.whl$/,
          use: [
            {
              loader: "file-loader",
              options: { name: "[name].[ext]", outputPath: "../" },
            },
          ],
        },
        {
          test: /\.(woff(2)?|ttf|otf|woff|woff2|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
          use: [
            {
              loader: "file-loader",
              options: { name: "[name].[ext]", outputPath: "../fonts" },
            },
          ],
        },
      ],
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: "../css/app.css" }),
      new CopyWebpackPlugin([{ from: "static/", to: "../" }]),
      new InjectManifest({ swSrc: "./js/sw.js", swDest: "../sw.js" }),
    ].concat(devMode ? [new HardSourceWebpackPlugin()] : []),
  };
};
