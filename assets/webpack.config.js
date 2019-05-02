const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin')

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    './js/app.js': ['./js/app.js'].concat(glob.sync('./vendor/**/*.js'))
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        // vue-loader config to load `.vue` files or single file components.
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            css: ['vue-style-loader', {
              loader: 'css-loader',
            }],
            js: [
              'babel-loader',
            ],
          },
          cacheBusting: true,
        },
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
    new VueLoaderPlugin()
  ],
  resolve: {
    alias: {
      Components: path.resolve(__dirname, 'js/components/'),
      Helpers: path.resolve(__dirname, 'js/helpers/'),
      Pages: path.resolve(__dirname, 'js/pages/'),
      Repositories: path.resolve(__dirname, 'js/repositories/'),
      Router: path.resolve(__dirname, 'js/router/'),
      Services: path.resolve(__dirname, 'js/services/'),
      Store: path.resolve(__dirname, 'js/store/')
    }
  }
});
