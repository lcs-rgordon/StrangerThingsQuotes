import SwiftUI

// Example JSON response
//
// This illustrates how to handle a JSON response which
// provides an array of objects.
//
// Recall that arrays are denoted by [ ] brackets.
//
// Objects are denoted by { }. Any time an object is provided,
// you must design a Swift structure to match it.
//
// From endpoint: https://strangerthings-quotes.vercel.app/api/quotes/5
//
// Documentation: https://github.com/shadowoff09/strangerthings-quotes
//
let exampleResponse = """
 
 [
    {
       "quote":"Our children don’t live here anymore. You didn’t know that?",
       "author":"Ted Wheeler"
    },
    {
       "quote":"Hey dingus! Your children are here again.",
       "author":"Robin Buckley"
    },
    {
       "quote":"Mouth breather",
       "author":"Eleven"
    },
    {
       "quote":"Just wait till we tell Will that Jennifer Hayes was crying at his funeral.",
       "author":"Dustin Henderson"
    },
    {
       "quote":"Hey, well, if we're both going crazy, then we'll go crazy together, right?",
       "author":"Mike Wheeler"
    }
 ]

"""

// Model
//
//
struct Quote: Codable {
    
    let quote: String
    let author: String
    
}

// Network service
//
//
func fetch() async -> [Quote] {

    // 1. Attempt to create a URL from the address provided
    let endpoint = "https://strangerthings-quotes.vercel.app/api/quotes/5"
    guard let url = URL(string: endpoint) else {
        print("Invalid address")
        return []
    }

    // 2. Fetch the raw data from the URL
    //
    // Network requests can potentially fail (throw errors) so
    // we complete them within a do-catch block to report errors if they
    // occur.
    //
    do {
        
        // Fetch the data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Create a decoder object to do most of the work for us
        let decoder = JSONDecoder()
        
        // Use the decoder object to convert the raw data into an array of the Quote data type
        let decodedData = try decoder.decode([Quote].self, from: data)

        // If we got here, we have received an array of quotes
        if decodedData.count > 0 {
            // There were for sure some quotes decoded, so let's return them
            return decodedData
        } else {
            return []
        }
        
    } catch {
        
        // Show an error that we wrote and understand
        print("Count not retrieve data from endpoint, or could not decode data.")
        print("----")
        
        // No quotes returned, return an empty array
        print(error.localizedDescription)
        return []
        
    }

    
}

// View
//
//
Task {
    // Get some quotes
    let someQuotes = await fetch()
    
    // So long as quotes were returned
    if someQuotes.count > 0 {
        for currentQuote in someQuotes {
            print(currentQuote.quote)
            print("-- \(currentQuote.author)")
        }
    } else {
        print("No quotes found. 😕")
    }
}


