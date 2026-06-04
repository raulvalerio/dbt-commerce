with 

source as (

    select * from {{ source('my_gcp_data', 'tlc_yellow_trips_2018_sample') }}

),

renamed as (

    select
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        rate_code,
        store_and_fwd_flag,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        imp_surcharge,
        total_amount,
        pickup_location_id,
        dropoff_location_id

    from source

)

select * from renamed