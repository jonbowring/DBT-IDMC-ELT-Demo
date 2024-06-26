with orders as (
    select 
    POS_TRANSACTIONID, 
    POS_TRANSACTIONDT, 
    STORE_ID, 
    STORE_CODE, 
    STORE_NAME, 
    STORE_LOCATION, 
    STORE_COUNTRY, 
    STORE_PHONE, 
    POS_CUSTOMER_ID, 
    POS_TERMINAL, 
    POS_MERCHANT, 
    POS_PERIOD, 
    POS_PAYMENT, 
    POS_CARDNUMBER, 
    POS_TOTALAMOUNTEXVAT, 
    POS_TOTALAMOUNTVAT, 
    POS_TOTALAMOUNT, 
    POS_ORDERTYPE 
    from 
    APAC_CDP_DEMO_DB.PUBLIC.JB_ORDERS
),

orderlines as (
    select
    LINEITEM_TRANSACTIONID, 
    LINEITEM_LINEID, 
    LINEITEM_PRODUCTID, 
    LINEITEM_PRODUCTDESCR, 
    LINEITEM_PRICEPERUNIT, 
    LINEITEM_UNITS, 
    LINEITEM_VAT_PERC, 
    LINEITEM_DISCOUNT, 
    LINEITEM_TOTALAMOUNT, 
    LINEITEM_STORECODE, 
    LINEITEM_ORDERTYPE
    from
    APAC_CDP_DEMO_DB.PUBLIC.JB_ORDERLINES
),

joiner as (
    select
    o.POS_TRANSACTIONID, 
    o.POS_TRANSACTIONDT, 
    o.STORE_ID, 
    o.STORE_CODE, 
    o.STORE_NAME, 
    o.STORE_LOCATION, 
    o.STORE_COUNTRY, 
    o.STORE_PHONE, 
    o.POS_CUSTOMER_ID, 
    o.POS_TERMINAL, 
    o.POS_MERCHANT, 
    o.POS_PERIOD, 
    o.POS_PAYMENT, 
    o.POS_CARDNUMBER, 
    o.POS_TOTALAMOUNTEXVAT, 
    o.POS_TOTALAMOUNTVAT, 
    o.POS_TOTALAMOUNT, 
    o.POS_ORDERTYPE,
    l.LINEITEM_TRANSACTIONID, 
    l.LINEITEM_LINEID, 
    l.LINEITEM_PRODUCTID, 
    l.LINEITEM_PRODUCTDESCR, 
    l.LINEITEM_PRICEPERUNIT, 
    l.LINEITEM_UNITS, 
    l.LINEITEM_VAT_PERC, 
    l.LINEITEM_DISCOUNT, 
    l.LINEITEM_TOTALAMOUNT, 
    l.LINEITEM_STORECODE, 
    l.LINEITEM_ORDERTYPE
    from
    orders o
    inner join orderlines l
    on (o.POS_TRANSACTIONID = l.LINEITEM_TRANSACTIONID)
),

aggregator as (
    select
    POS_TRANSACTIONID,
    sum(LINEITEM_TOTALAMOUNT) as Sum_Total
    from
    joiner
    group by
    POS_TRANSACTIONID
),

expression as (
    select
    distinct
    a.POS_TRANSACTIONID, 
    a.POS_TRANSACTIONDT, 
    a.STORE_ID, 
    a.STORE_CODE, 
    upper(a.STORE_NAME) as STORE_NAME, 
    a.STORE_LOCATION, 
    a.STORE_COUNTRY, 
    a.STORE_PHONE, 
    a.POS_CUSTOMER_ID, 
    a.POS_TERMINAL, 
    a.POS_MERCHANT, 
    a.POS_PERIOD, 
    a.POS_PAYMENT, 
    a.POS_CARDNUMBER, 
    a.POS_TOTALAMOUNTEXVAT, 
    a.POS_TOTALAMOUNTVAT, 
    a.POS_TOTALAMOUNT, 
    a.POS_ORDERTYPE,
    b.Sum_Total
    from
    joiner a
    inner join aggregator b 
    on (a.POS_TRANSACTIONID = b.POS_TRANSACTIONID)
)

select
*
from
expression