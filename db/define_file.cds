using { cuid } from '@sap/cds/common';
using { managed }  from '@sap/cds/common';
//cuid - shortcut to add canonical, universally unique primary keys to ur entity definitions
entity File : cuid , managed { 
    title : String;
    fileType : String; //tells the browser how to handle file?
    content : LargeBinary;
    //createdAt : Timestamp; //sendAT?? // apparentlly menaged already takes care od the info like createdAt modifyedBy etc..; 
}
