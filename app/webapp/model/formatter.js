sap.ui.define([], function () {
    "use strict";

    return {

        /**
         * Rounds the number unit value to 2 digits
         * @public
         * @param {string} sValue the number string to be rounded
         * @returns {string} sValue with 2 digits rounded
         */
        numberUnit : function (sValue) {
            if (!sValue) {
                return "";
            }
            return parseFloat(sValue).toFixed(2);
        },

        beautifyName : function(iValue) {

            var sReturn = "";
            
            if (iValue == "01") {
      
                sReturn = "customer";      
      
            } else if (iValue == "02") {
      
              sReturn = "supplier";
      
            } else if (iValue == "03") {
      
              sReturn = "excluded";
      
            } else {
                sReturn = iValue;
            }
      
            // return sReturn to the view
            return sReturn;    
      
          }

    };

});