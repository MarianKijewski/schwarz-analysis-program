using {schwarz.analysis as db} from '../db/schema';

service DataExchangeService {
    @odata.draft.enabled
    entity BusinessPartners as projection on db.BusinessPartners;
    
    @odata.draft.enabled
    entity DataAssets as projection on db.DataAssets;
    
    @odata.draft.enabled
    entity DataExchanges as projection on db.DataExchanges;
}
