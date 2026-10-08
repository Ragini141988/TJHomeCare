# TJ Home Care - ASP.NET Web Forms

This is a new ASP.NET Web Forms (.NET Framework 4.8.1) starter solution based on the current TJ Homecare website structure.

## Structure
- `Site.master` - shared header, navigation and footer
- `Default.aspx` - home page
- `Default.aspx.cs` - home page code-behind
- `About.aspx` / `Contact.aspx` - placeholder pages using the same master page
- `Content/Site.css` - responsive site styling
- `Web.config` - ASP.NET configuration
- `Images/` - place the final production logo/hero images here

## Visual Studio
Open `TJHomeCare.sln` in Visual Studio 2022 and run the project.

The page is intentionally built without WordPress/Astra dependencies. The Master Page owns the common layout so additional pages can be added consistently.
