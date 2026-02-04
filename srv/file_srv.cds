// using { cuid } from '@sap/cds/common'; ??

service FileService {
    action uploadFile();
    action downloadFile(id : UUID) returns Binary;
}
