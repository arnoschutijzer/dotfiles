module.exports = {
  config: {
    // default font size in pixels for all tabs
    fontSize: 16,

    // font family with optional fallbacks
    fontFamily: '"Fira Code", Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: 'rgba(177, 177, 177, 0.5)',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BEAM',

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    backgroundColor:"rgba(0,0,0,0.5)",
    vibrancy:"",
        
    // border color (window, tabs)
    borderColor: '#000',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px 14px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#000000',
      red: '#FF5252',
      green: '#81C784',
      yellow: '#FFEE58',
      blue: '#448AFF',
      magenta: '#B388FF',
      cyan: '#00ACC1',
      white: '#EEEEEE',
      lightBlack: '#00f00f',
      lightRed: '#EF9A9A',
      lightGreen: '#A5D6A7',
      lightYellow: '#FFF59D',
      lightBlue: '#90CAF9',
      lightMagenta: '#B39DDB',
      lightCyan: '#80DEEA',
      lightWhite: '#F5F5F5'
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: '',

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ['--login'],

    // for environment variables
    env: {},

    // set to false for no bell
    bell: 'SOUND',

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyperterm.org/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    'hypercwd',
    'hyperterm-tab-icons',
    // 'hyper-material-vibrancy',
    'hyper-statusline',
    'hyper-fileio',
    'hyper-alt-click'
  ],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  updateChannel: 'canary'
};
