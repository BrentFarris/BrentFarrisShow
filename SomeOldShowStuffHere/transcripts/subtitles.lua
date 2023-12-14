-- Open the input file
local inputFileName = "subtitles.txt"
local inputFile = assert(io.open(inputFileName, "r"))

-- Create the output file
local outputFileName = "subtitles.srt"
local outputFile = assert(io.open(outputFileName, "w"))

-- Create the raw text output file
local outputRawFileName = "subtitles.raw.text"
local outputRawFile = assert(io.open(outputRawFileName, "w"))

-- Initialize subtitle index
local subtitleIndex = 1

local timestamp, text
-- Read the file line by line
for line in inputFile:lines() do
  if not timestamp then
    timestamp = line:match("%d+:%d+")
  else
    text = line:match(".+")
    outputRawFile:write(text .. "\n")
  end
  
  if timestamp and text then
      -- Write the subtitle index
      outputFile:write(subtitleIndex .. "\n")
      
      -- Write the timestamp in the required format (00:00:00,000)
      local hours, minutes, seconds = timestamp:match("(%d+):(%d+):(%d+)")
      if not seconds then
        minutes, seconds = timestamp:match("(%d+):(%d+)")
        hours = 0
      end
        
      --local milliseconds = tonumber(seconds) * 1000
      local milliseconds = 0
      outputFile:write(string.format("%02d:%02d:%02d,%03d", hours, minutes, seconds, milliseconds) .. " --> ")
      
      -- Calculate the end timestamp (assuming each subtitle lasts for 2 seconds)
      local endTimestamp = string.format("%02d:%02d:%02d,%03d", hours, minutes, seconds + 2, milliseconds)
      outputFile:write(endTimestamp .. "\n")
      
      -- Write the text
      outputFile:write(text .. "\n\n")
      
      -- Increment the subtitle index
      subtitleIndex = subtitleIndex + 1
      timestamp = nil
      text = nil
  end
end

-- Close the files
inputFile:close()
outputFile:close()
outputRawFile:close()
