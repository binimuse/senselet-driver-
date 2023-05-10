class GetConstatsandDriverQuery {
  static dynamic getConstatsanddriver(String id) {
    return """
{
  credentials(where: {id: {_eq: "$id"}}) {
    first_name
    father_name
    is_active
    username
    roles
    email
    birthdate
    gender
  }
  
  
  constants {
    id
    address
    phone
    short_code
    tone_price
    tone_price
    fb_id
    telegram_id
    website
    about_us
  }


  vehicles(where: {credential_id: {_eq: "$id"}}) {
    active
    driver_id
    id
    location
    photos
    plate_number
    vehicle_type {
      name
      kg
      description
      id
    }
  }

}

    """;
  }
}
