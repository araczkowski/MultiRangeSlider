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
 * @constructor
 * @param {String} selector jQuery selector
 * @param {Object} userOptions (optional) Custom options object that overrides default
 * {
 *      @property {Number} userOptions.min Slider minimum value
 *      @property {Number} userOptions.max Slider maximum value
 *      @property {Number} userOptions.step Slider sliding step
 *      @property {Number} userOptions.gap Minimum gap between handles when add/remove range controls are visible
 *      @property {Number} userOptions.newlength Default length for newly created range. Will be adjusted between surrounding handles if not fitted
 *      @property {Object} userOptions.handleLabelDispFormat mrdad handle label format default hh24:mi
 *      @property {Object} userOptions.stepLabelDispFormat mrdad step Label format default hh24
 *      @property {Array} userOptions.blocksToolbar  blocks definition for blocks toolbar blocksArray example: Array([{value: 30}, {value: 60}, {value: 120}...]) (we are expecting soon more information (like colour etc.)about blocks from DB, that is why blocks are objects)
 *      @property {String} userOptions.mode pluugin work mode: ranges or blocks
 * }
 */

window.Mrs = function(selector, userOptions) {}
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

**addBlocks**
```javascript
/**
 * Adds multiple block to the slider scale
 * @param {Array} blocksArray example: Array([[660, 30],[990, 60]...])
 * @return {Object} self instance of Mrs class
 */

Mrs.addBlocks = function(blocksArray) {}
```




Mrs class interface continuation
=========================
=
**getPeriod**
```javascript
/**
 * Get period by id
 * @param {Number} id
 * @return {Object}
 */

Mrs.getPeriod = function(id) {}
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

=
**setDeletePeriodConfirmCallback**
```javascript
/**
 * Sets callback function that can be used for period delete confirmation window
 *
 * @param {Function} confirmFunction
 *      stores a callback function
 *      function args:
 *          1. period - instance of current period.toPublic() object to be passed to confirmation window
 *          2. callback result flag of boolean
 *
 * @example
 *      Mrs.setDeletePeriodConfirmCallback(function(period, callback) {
 *          callback(function() {
 *             return confirm('Delete period between ' + period.getAbscissas()[0] + ' and ' + period.getAbscissas()[1] + ' ?');
 *          }());
 *      });
 * @return {Object} self instance of Mrs class
 */

Mrs.setDeletePeriodConfirmCallback = function(confirmFunction) {}
```

=
**setAddPeriodConfirmCallback**
```javascript
/**
 * Sets callback function that can be used for period add confirmation window
 *
 * @param {Function} confirmFunction
 *      stores a callback function
 *      function args:
 *          1. period - instance of new period.toPublic() object that can be confirmed or rejected
 *          2. callback result flag of boolean
 *
 * @example
 *      Mrs.setAddPeriodConfirmCallback(function(period, callback) {
 *          callback(function() {
 *             return confirm('Add period between ' + period.getAbscissas()[0] + ' and ' + period.getAbscissas()[1] + ' ?');
 *          }());
 *      });
 * @return {Object} self instance of Mrs class
 */

Mrs.setAddPeriodConfirmCallback = function(confirmFunction) {}
```

=
**setOnHandleMouseenterCallback**
```javascript
/**
 * Sets callback function for handle's mouseenter event
 *
 * @param {Function} callbackFunction
 *      stores a callback function
 *      function args:
 *          1. context - jQuery object of hovered handle
 *          2. period - instance of period.toPublic() object that is linked to hovered handle
 *          3. edgeIndex - integer number[0-1] indicating left or right handle triggered
 *
 * @example
 *      Mrs.setOnHandleMouseenterCallback(function(context, period, edgeIndex) {
 *          var handlePosition = context.offset().left;
 *          var periodId = period.getId();
 *          var handleAbscissa = period.getAbscissas()[edgeIndex];
 *          //...
 *      });
 * @return {Object} self instance of Mrs class
 */

Mrs.setOnHandleMouseenterCallback = function(callbackFunction) {}
```

=
**setOnHandleSlideCallback**
```javascript
/**
 * Sets callback function for handle's slide event
 *
 * @param {Function} callbackFunction
 *      stores a callback function
 *      function args:
 *          1. context - jQuery object of slided handle
 *          2. period - instance of period.toPublic() object that is linked to slided handle
 *          3. edgeIndex - integer number[0-1] indicating left or right handle triggered
 *
 * @example
 *      Mrs.setOnHandleSlideCallback(function(context, period, edgeIndex) {
 *          var handlePosition = context.offset().left;
 *          var periodId = period.getId();
 *          var handleAbscissa = period.getAbscissas()[edgeIndex];
 *          //...
 *      });
 * @return {Object} self instance of Mrs class
 */

Mrs.setOnHandleSlideCallback = function(callbackFunction) {}
```


=========================




