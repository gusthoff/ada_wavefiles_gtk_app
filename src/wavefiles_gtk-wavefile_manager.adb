-------------------------------------------------------------------------------
--
--                        WAVEFILES GTK APPLICATION
--
--                             Wavefile Manager
--
-- The MIT License (MIT)
--
-- Copyright (c) 2017 Gustavo A. Hoffmann
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and /
-- or sell copies of the Software, and to permit persons to whom the Software
-- is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.
-------------------------------------------------------------------------------

with Interfaces;
with Ada.Characters.Latin_1;

with Audio.Wavefiles;
with Audio.RIFF.Wav.Formats;
with Audio.RIFF.Wav.GUIDs;

package body WaveFiles_Gtk.Wavefile_Manager is

   --------------
   -- Get_Info --
   --------------

   function Get_Info (Wavefile : String) return String is
      WF_In       : Audio.Wavefiles.Wavefile;
      RIFF_Data   : Audio.RIFF.Wav.Formats.Wave_Format_Extensible;

      function Get_RIFF_GUID_String (Sub_Format : Audio.RIFF.Wav.Formats.GUID) return String;
      function Get_RIFF_Extended (RIFF_Data : Audio.RIFF.Wav.Formats.Wave_Format_Extensible)
                                  return String;

      package Wav_Read  renames  Audio.Wavefiles;
      use Interfaces;

      function Get_RIFF_GUID_String (Sub_Format : Audio.RIFF.Wav.Formats.GUID) return String
      is
         use type Audio.RIFF.Wav.Formats.GUID;
      begin
         if Sub_Format = Audio.RIFF.Wav.GUIDs.GUID_Undefined then
            return "Subformat: undefined";
         elsif Sub_Format = Audio.RIFF.Wav.GUIDs.GUID_PCM then
            return "Subformat: KSDATAFORMAT_SUBTYPE_PCM (IEC 60958 PCM)";
         elsif Sub_Format = Audio.RIFF.Wav.GUIDs.GUID_IEEE_Float then
            return "Subformat: KSDATAFORMAT_SUBTYPE_IEEE_FLOAT " &
              "(IEEE Floating-Point PCM)";
         else
            return "Subformat: unknown";
         end if;
      end Get_RIFF_GUID_String;

      function Get_RIFF_Extended (RIFF_Data : Audio.RIFF.Wav.Formats.Wave_Format_Extensible)
                                  return String
      is
         S : constant String :=
               ("Valid bits per sample: "
                & Unsigned_16'Image (RIFF_Data.Valid_Bits_Per_Sample));
      begin
         if RIFF_Data.Size > 0 then
            return (S
                    & Ada.Characters.Latin_1.LF
                    & Get_RIFF_GUID_String (RIFF_Data.Sub_Format));
         else
            return "";
         end if;
      end Get_RIFF_Extended;
   begin
      Wav_Read.Open (WF_In, Wav_Read.In_File, Wavefile);
      RIFF_Data := Wav_Read.Format_Of_Wavefile (WF_In);
      Wav_Read.Close (WF_In);

      declare
         S_Wav_1 : constant String :=
                     ("Bits per sample: "
                      & Audio.RIFF.Wav.Formats.Wav_Bit_Depth'Image (RIFF_Data.Bits_Per_Sample)
                      & Ada.Characters.Latin_1.LF
                      & "Channels: "
                      & Unsigned_16'Image (RIFF_Data.Channels)
                      & Ada.Characters.Latin_1.LF
                      & "Samples per second: "
                      & Audio.RIFF.Wav.Formats.Wav_Sample_Rate'Image (RIFF_Data.Samples_Per_Sec)
                      & Ada.Characters.Latin_1.LF
                      & "Extended size: "
                      & Unsigned_16'Image (RIFF_Data.Size)
                      & Ada.Characters.Latin_1.LF);
         S_Wav_2 : constant String := Get_RIFF_Extended (RIFF_Data);
      begin
         return "File: "    & Wavefile & Ada.Characters.Latin_1.LF
           & S_Wav_1 & S_Wav_2;
      end;
   end Get_Info;

end WaveFiles_Gtk.Wavefile_Manager;
