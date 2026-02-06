namespace schwarz.analysis;

entity BusinessPartners {
    key ID          : UUID;
        name        : String(100);
        email       : String(100);
        phone       : String(20);
        address     : String(200);
        partnerType : String(20);
        isActive    : Boolean default true;
        createdAt   : Timestamp;
        modifiedAt  : Timestamp;
}

entity DataAssets {
    key ID          : UUID;
        name        : String(100);
        description : String(500);
        category    : String(50);
        owner       : Association to BusinessPartners;
        url         : String(500);
        size        : Integer;
        format      : String(20);
        isPublic    : Boolean default false;
        createdAt   : Timestamp;
        modifiedAt  : Timestamp;
}

entity DataExchanges {
    key ID           : UUID;
        asset        : Association to DataAssets;
        sender       : Association to BusinessPartners;
        receiver     : Association to BusinessPartners;
        status       : String(20);
        initiatedAt  : Timestamp;
        completedAt  : Timestamp;
        comments     : String(500);
}
