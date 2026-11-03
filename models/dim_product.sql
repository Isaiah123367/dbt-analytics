with stg_products as (
    select * from {{ source('northwind','Products') }}
),
stg_suppliers as (
    select * from {{ source('northwind','Suppliers') }}
),
stg_categories as (
    select * from {{ source('northwind','Categories') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['p.productid']) }} as productkey,
    p.productid,
    p.productname,
    s.companyname as suppliercompanyname,
    c.categoryname,
    c.description as categorydescription,
    p.quantityperunit,
    case when p.discontinued::varchar in ('1', 'true', 'TRUE', 'True', 'Y') then 'Y' else 'N' end as discontinued
from stg_products p
    left join stg_suppliers s on p.supplierid = s.supplierid
    left join stg_categories c on p.categoryid = c.categoryid
