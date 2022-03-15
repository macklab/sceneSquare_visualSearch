var visual_search_grid = (function (jspsych) {
    "use strict";
  
    const info = {
        name: "visual-search-grid",
        parameters: {
          /** The target image to be displayed. This must specified when using the target, foil and set_size parameters to define the stimuli set, rather than the stimuli parameter. */
          target: {
              type: ParameterType.IMAGE,
              pretty_name: "Target",
              default: null,
          },
          /** The image to use as the foil/distractor. This must specified when using the target, foil and set_size parameters to define the stimuli set, rather than the stimuli parameter. */
          foils: {
              type: ParameterType.IMAGE,
              pretty_name: "Foil",
              default: null,
          },
          /** How many items should be displayed, including the target when target_present is true? This must specified when using the target, foil and set_size parameters to define the stimuli set, rather than the stimuli parameter. */
          set_size: {
              type: ParameterType.INT,
              pretty_name: "Set size",
              default: null,
          },
          /** Array containing one or more image files to be displayed. This only needs to be specified when NOT using the target, foil, and set_size parameters to define the stimuli set. */
          stimuli: {
              type: ParameterType.IMAGE,
              pretty_name: "Stimuli",
              default: null,
              array: true,
          },
          /**
           * Is the target present?
           * When using the target, foil and set_size parameters, false means that the foil image will be repeated up to the set_size,
           * and if true, then the target will be presented along with the foil image repeated up to set_size - 1.
           * When using the stimuli parameter, this parameter is only used to determine the response accuracy.
           */
          target_present: {
              type: ParameterType.BOOL,
              pretty_name: "Target present",
              default: undefined,
          },
          /** Path to image file that is a fixation target. */
          fixation_image: {
              type: ParameterType.IMAGE,
              pretty_name: "Fixation image",
              default: undefined,
          },
          /** Two element array indicating the height and width of the search array element images. */
          target_size: {
              type: ParameterType.INT,
              pretty_name: "Target size",
              array: true,
              default: [50, 50],
          },
          /** Two element array indicating the height and width of the fixation image. */
          fixation_size: {
              type: ParameterType.INT,
              pretty_name: "Fixation size",
              array: true,
              default: [16, 16],
          },
          /** The size of a singel cell in the search grid in pixels. */
          grid_cell_size: {
              type: ParameterType.INT,
              pretty_name: "A single cell size on the grid",
              array: true, 
              default: [100, 100],
          },
          /** The dimension of the entire grid (how many cells) **/
          grid_dimension: {
              type: ParameterType.INT,
              pretty_name: "Number of rows and columns on the grid",
              array: true,
              default: [4,4]
          },
          /** Jitter setting **/
          jitter_size: {
              type: ParameterType.INT,
              pretty_name: "Stimulus jitter size inside a cell",
              default: 0,
          },
          jitter_direction: {
              type: ParameterType.INT,
              pretty_name: "Stimulus jitter direction inside a cell",
              default: 0, // 0:random,1:up,2:down,3:left,4:right
          },
          /** The key to press if the target is present in the search array. */
          target_present_key: {
              type: ParameterType.KEY,
              pretty_name: "Target present key",
              default: "j",
          },
          /** The key to press if the target is not present in the search array. */
          target_absent_key: {
              type: ParameterType.KEY,
              pretty_name: "Target absent key",
              default: "f",
          },
          /** The maximum duration to wait for a response. */
          trial_duration: {
              type: ParameterType.INT,
              pretty_name: "Trial duration",
              default: null,
          },
          /** How long to show the fixation image for before the search array (in milliseconds). */
          fixation_duration: {
              type: ParameterType.INT,
              pretty_name: "Fixation duration",
              default: 1000,
          },
        },
      };
  
    /**
     * **visual-search-grid**
     *
     * jsPsych plugin to display a set of objects, with or without a target, scattered in a grid.
     * Subject responds with key press to whether or not the target is present.
     * Revised from "plugin-visual-saerch-grid" in jsPsych 7.0
     *
     * @author Gaeun Son 
     **/

    class PluginNamePlugin {
      constructor(jsPsych) {
        this.jsPsych = jsPsych;
      }
      trial(display_element, trial) {
        // data saving
        var trial_data = {
          parameter_name: "parameter value",
        };
        // end trial
        this.jsPsych.finishTrial(trial_data);
      }
    }
    PluginNamePlugin.info = info;
  
    return PluginNamePlugin;
  })(jsPsychModule);




type Info = typeof info;

/**
 * **visual-search-grid**
 *
 * jsPsych plugin to display a set of objects, with or without a target, scattered in a grid.
 * Subject responds with key press to whether or not the target is present.
 * Revised from "plugin-visual-saerch-grid" in jsPsych 7.0
 *
 * @author Gaeun Son 
 **/
class VisualSearchGridPlugin implements JsPsychPlugin<Info> {
  static info = info;

  constructor(private jsPsych: JsPsych) {}

  trial(display_element: HTMLElement, trial: TrialType<Info>) {

    // grid params (all pixels)
    var cellw = trial.grid_cell_size[0];
    var cellh = trial.grid_cell_size[1];
    var hcellw = cellw/2;
    var hcellh = cellh/2;
    var n_rows = trial.grid_dimension[0]; 
    var n_columns = trial.grid_dimension[1];    
    var paperw = cellw * n_rows;
    var paperh = cellh * n_columns;
    var cell_centers = []; // list of array
    for (var c=1; c<n_columns-1; c++){
      for (var r=1; r<n_rows-1; r++){
        var center_x = paperw - hcellw + cellw*r;
        var center_y = paperw - hcellh + cellh*c;
        cell_centers.push([center_x, center_y]); 
      }
    }

    // stimuli width, height
    var stimh = trial.target_size[0];
    var stimw = trial.target_size[1];
    var hstimh = stimh / 2;
    var hstimw = stimw / 2;

    // fixation location
    var fix_loc = [
      Math.floor(paperw / 2 - trial.fixation_size[0] / 2),
      Math.floor(paperh / 2 - trial.fixation_size[1] / 2),
    ];

    // check for correct combination of parameters and create stimuli set
    var possible_display_locs: number;
    var to_present = [];
    if (trial.target !== null && trial.foil !== null && trial.set_size !== null) {
      possible_display_locs = trial.set_size;
      if (trial.target_present) {
        for (var i = 0; i < trial.set_size - 1; i++) {
          to_present.push(trial.foil);
        }
        to_present.push(trial.target);
      } else {
        for (var i = 0; i < trial.set_size; i++) {
          to_present.push(trial.foil);
        }
      }
    } else if (trial.stimuli !== null) {
      possible_display_locs = trial.stimuli.length;
      to_present = trial.stimuli;
    } else {
      console.error(
        "Error in visual-search-circle plugin: you must specify an array of images via the stimuli parameter OR specify the target, foil and set_size parameters."
      );
    }

    // possible stimulus locations on the grid
    function getRandomSubarray(arr, size) { // first, define random sample function
      var shuffled = arr.slice(0), i = arr.length, temp, index;
      while (i--) {
          index = Math.floor((i + 1) * Math.random());
          temp = shuffled[index];
          shuffled[index] = shuffled[i];
          shuffled[i] = temp;
      }
      return shuffled.slice(0, size);
    }    
    var random_cells = getRandomSubarray(cell_centers, trial.size_size);  
    var display_locs = [];  
    for (var i = 0; i < random_cells.length; i++) {
      // jitter setting
      if (trial.jitter_direction==0){var this_jitter_dir = Math.ceil(Math.random()*4)};
      if (this_jitter_dir <=2){
        var jitter_x = 0; var jitter_y = this_jitter_dir;
      } else if (this_jitter_dir > 2){
        var jitter_x = this_jitter_dir; var jitter_y = 0;
      }
      display_locs.push([
        random_cells[i][0] + jitter_x - hstimw, // x start
        random_cells[i][1] + jitter_y - hstimh // y start
      ]);
    }

    // get target to draw on
    display_element.innerHTML +=
      '<div id="jspsych-visual-search-circle-container" style="position: relative; width:' +
      paperw +
      "px; height:" +
      paperh +
      'px"></div>';
    var paper = display_element.querySelector("#jspsych-visual-search-circle-container");

    const show_fixation = () => {
      // show fixation
      //var fixation = paper.image(trial.fixation_image, fix_loc[0], fix_loc[1], trial.fixation_size[0], trial.fixation_size[1]);
      paper.innerHTML +=
        "<img src='" +
        trial.fixation_image +
        "' style='position: absolute; top:" +
        fix_loc[0] +
        "px; left:" +
        fix_loc[1] +
        "px; width:" +
        trial.fixation_size[0] +
        "px; height:" +
        trial.fixation_size[1] +
        "px;'></img>";

      // wait
      this.jsPsych.pluginAPI.setTimeout(() => {
        // after wait is over
        show_search_array();
      }, trial.fixation_duration);
    };

    const end_trial = (rt: number, correct: boolean, key_press: string) => {
      // data saving
      var trial_data = {
        correct: correct,
        rt: rt,
        response: key_press,
        locations: display_locs,
        target_present: trial.target_present,
        set_size: trial.set_size,
      };

      // go to next trial
      this.jsPsych.finishTrial(trial_data);
    };

    show_fixation();

    const show_search_array = () => {
      for (var i = 0; i < display_locs.length; i++) {
        paper.innerHTML +=
          "<img src='" +
          to_present[i] +
          "' style='position: absolute; top:" +
          display_locs[i][0] +
          "px; left:" +
          display_locs[i][1] +
          "px; width:" +
          trial.target_size[0] +
          "px; height:" +
          trial.target_size[1] +
          "px;'></img>";
      }

      var trial_over = false;

      const after_response = (info: { key: string; rt: number }) => {
        trial_over = true;

        var correct = false;

        if (
          (this.jsPsych.pluginAPI.compareKeys(info.key, trial.target_present_key) &&
            trial.target_present) ||
          (this.jsPsych.pluginAPI.compareKeys(info.key, trial.target_absent_key) &&
            !trial.target_present)
        ) {
          correct = true;
        }

        clear_display();

        end_trial(info.rt, correct, info.key);
      };

      var valid_keys = [trial.target_present_key, trial.target_absent_key];

      const key_listener = this.jsPsych.pluginAPI.getKeyboardResponse({
        callback_function: after_response,
        valid_responses: valid_keys,
        rt_method: "performance",
        persist: false,
        allow_held_key: false,
      });

      if (trial.trial_duration !== null) {
        this.jsPsych.pluginAPI.setTimeout(() => {
          if (!trial_over) {
            this.jsPsych.pluginAPI.cancelKeyboardResponse(key_listener);

            trial_over = true;

            var rt = null;
            var correct = false;
            var key_press = null;

            clear_display();

            end_trial(rt, correct, key_press);
          }
        }, trial.trial_duration);
      }

      function clear_display() {
        display_element.innerHTML = "";
      }
    };

    // helper function for determining stimulus locations
    function cosd(num: number) {
      return Math.cos((num / 180) * Math.PI);
    }

    function sind(num: number) {
      return Math.sin((num / 180) * Math.PI);
    }
  }
}

export default VisualSearchCirclePlugin;
