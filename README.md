#  Weather

This is a weather app for the iPad. It is part of the lecture
*Mobile App Development* at DHBW Mannheim and the first project I did using Swift.

## Status of the app

**The following features work:**

- Display 24h forecast
- Display 10d forecast
- Display current weather

**The following features do not work:**

- Retrieve current location

**The following features were planned but not implemented:**

- Custom locations
- Detailed weather metrics
- Better design

## Usage

This is a normal iPad app that can be started using Xcode. There is no API key
needed. As the location does not work, there is a mock returning the location
of Cologne. You can replace the mock be the (not working) GPS version in file
`Views/MainView.swift`.
