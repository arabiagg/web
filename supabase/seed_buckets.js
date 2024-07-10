const supabase_client = require('@supabase/supabase-js')

require('dotenv').config({ path: '.env'})

const bracketInfo =
  {
      "sections": [
          { "type": "markdown", "content": "# hello *world*" },
          { "type": "bracket", "content": [
                  {
                      "matches": [
                          {"id":"dffcf3c7-fa1f-40df-bc6f-c59e268fddd0", "is_ghost":false,"first_round":true,"last_round":false},
                          {"id":"748accf6-cdbf-44aa-8b9c-7e6f37954381","is_ghost":false,"first_round":true,"last_round":false},
                          {"id":"27c9077b-2d3f-49d5-b919-da2a5b8b2629","is_ghost":false,"first_round":true,"last_round":false},
                          {"id":"3701918d-7d7d-493a-abd5-ccb1d4db3044","is_ghost":false,"first_round":true,"last_round":false}
                      ],
                      "name": "Round 1"
                  },
                  {
                      "matches": [
                          {"id":"a22c3c0b-7808-4daa-adba-95842fdd52a1", "is_ghost":false,"first_round":false,"last_round":false},
                          {"id":"3f16992c-92ad-4d30-b446-db1bb3889632","is_ghost":false,"first_round":false,"last_round":false}
                      ],
                      "name": "Round 2"
                  },
                  {
                      "matches": [{"id":"9d236392-ef1b-49c7-8eaf-8d7aef7e3572","is_ghost":false,"first_round":false,"last_round":true}],
                      "name": "Final"
                  }
              ]
          }
      ]
  }
const bracketBlob= new Blob([JSON.stringify(bracketInfo, null, 2)], {type: "application/json"})

async function seedStorage() {
    const url = process.env.SUPABASE_URL
    const key = process.env.SUPABASE_SERVICE_KEY

    console.log("Connecting to client...")
    const supabase = supabase_client.createClient(url, key)

    console.log("Creating storage...")
    const { error: createStorageError} = await supabase.storage.createBucket("tournament_phases", {
        public: true
    })

    if (createStorageError !== null) {
        console.error(createStorageError.message, createStorageError.cause, createStorageError.stack)
    }


    console.log("Seeding storage...")
    const { error: uploadError} = await supabase.storage.from("tournament_phases")
        .upload("a7bddeaa-ca55-46c0-863a-b9a83650daee.json", bracketBlob)

    if (uploadError !== null) {
        console.error(uploadError.message, uploadError.cause, uploadError.stack)
        throw new Error("Failed to upload phase data to bucket")
    }
}


seedStorage()
