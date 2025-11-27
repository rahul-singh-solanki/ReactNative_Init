module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    [
      'babel-plugin-module-resolver',
      {
        root: ['.'],
        alias: {
          assets: './src/assets/',
          theme: './src/theme/',
          hooks: './src/hooks/',
          store: './src/store/',
          screens: './src/screens/',
          utils: './src/utils/',
          types: './src/types/',
          components: './src/components/',
          api: './src/api/',
          navigator: './src/navigator/',
        }
      }
    ],
    'react-native-worklets/plugin'
  ]
}
