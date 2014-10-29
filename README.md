MultiRangeSlider (Mrs)
===================

Extends jquery-ui slider widget to include multiple ranges.
Live example at jsFiddle http://jsfiddle.net/araczkowski/et4dmz1w/embedded/result/


![alt tag](https://raw.githubusercontent.com/araczkowski/MrDad/master/app/images/ranges.png)


TODO
===========================

***split the code***
***add a possibility to have many (same type) regions on one page***
****load the code only once****
****add a unique identifier to each region instance (when we click on one block change the things only on this instance not for each region etc.)****
***add a possibility to dynamically change the step value***
***other smaller things like parameter for displaying or not steps labels etc.***



How To Start (to develop the plugin)
===========================

**NPM**
```javascript
npm install
```

**Bower**
```javascript
bower install
```

**Grunt**
```javascript
grunt serve
```


Mrs class constructor
===========================
**Mrs**
```javascript
/**
* @class Mrs
*
* @constructor
* @param {String} elementId, this id will be used to create jQuery selector
* @param {Object} userOptions (optional) Custom options object that overrides default
* {
*      @property {Number} userOptions.min Slider minimum value
*      @property {Number} userOptions.max Slider maximum value
*      @property {Number} userOptions.step Slider sliding step
*      @property {Number} userOptions.gap Minimum gap between handles when add/remove range controls are visible
*      @property {Number} userOptions.newlength Default length for newly created range. Will be adjusted between surrounding handles if not fitted
*      @property {Object} userOptions.handleLabelDispFormat mrs handle label format default hh24:mi
*      @property {Object} userOptions.stepLabelDispFormat mrs step Label format default hh24
* }
*/

window.Mrs = function(elementId, userOptions) {}
```


Mrs class interface
=========================


**addPeriods**
```javascript
/**
 * Adds multiple periods and rebuilds the Mrs slider
 * @param {Array} periodsArray example: Array([[660, 90],[990, 120]...])
 * @return {Object} self instance of am.Mrs class
 */

Mrs.addPeriods = function(periodsArray) {}
```

=
**getPeriods**
```javascript
/**
 * Gets all periods for this Mrs instance
 * @return {Array} of each period.toPublic() object
 */

Mrs.getPeriods = function() {}
```


=========================




