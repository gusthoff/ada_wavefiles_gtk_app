-------------------------------------------------------------------------------
--
--                        WAVEFILES GTK APPLICATION
--
--                             Main Application
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

with Gtk.Main;
with Gtk.Enums;
with Gtk.Widget;

with WaveFiles_Gtk.Menu;
with WaveFiles_Gtk.Wavefile_List;

with Gtk.Label;

package body WaveFiles_Gtk is

   procedure On_Destroy
     (W     : access Gtk.Widget.Gtk_Widget_Record'Class);

   procedure Create_Window;

   Main_Win             : Gtk.Window.Gtk_Window;
   Vbox                 : Gtk.Box.Gtk_Vbox;

   Wavefile_Info : Gtk.Label.Gtk_Label;

   ----------------
   -- On_Destroy --
   ----------------

   procedure On_Destroy
     (W : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
      pragma Unreferenced (W);
   begin
      Destroy_Window;
   end On_Destroy;

   -------------------
   -- Create_Window --
   -------------------

   procedure Create_Window is
   begin
      --  Create the main window
      Gtk.Window.Gtk_New
        (Window   => Main_Win,
         The_Type => Gtk.Enums.Window_Toplevel);

      --  From Gtk.Widget:
      Main_Win.Set_Title (Title  => "Wavefiles Gtk App");
      Main_Win.Resize (Width  => 800, Height => 640);

      --  The global box
      Gtk.Box.Gtk_New_Vbox (Vbox, Homogeneous => False, Spacing => 0);
      Main_Win.Add (Vbox);

      --  Create menu
      WaveFiles_Gtk.Menu.Create;

      --  Add tree
      WaveFiles_Gtk.Wavefile_List.Create (Vbox);


      --  Add info view
      Gtk.Label.Gtk_New (Wavefile_Info);
      Wavefile_Info.Set_Valign (Gtk.Widget.Align_Start);
      Wavefile_Info.Set_Halign (Gtk.Widget.Align_Start);
      Vbox.Pack_Start (Wavefile_Info, True, True, 0);

      --  Construct the window and connect various callbacks
      Main_Win.On_Destroy (On_Destroy'Access);

      Vbox.Show_All;
      Main_Win.Show_All;
   end Create_Window;

   -----------------------
   -- Set_Wavefile_Info --
   -----------------------

   procedure Set_Wavefile_Info (Info : String) is
   begin
      Wavefile_Info.Set_Label (Info);
   end Set_Wavefile_Info;

   --------------------
   -- Destroy_Window --
   --------------------

   procedure Destroy_Window is
   begin
      Gtk.Main.Main_Quit;
   end Destroy_Window;

   ------------
   -- Create --
   ------------

   procedure Create is
   begin
      --  Initializes GtkAda
      Gtk.Main.Init;

      Create_Window;

      --  Signal handling loop
      Gtk.Main.Main;
   end Create;

   ----------------
   -- Get_Window --
   ----------------

   function Get_Window
     return not null access Gtk.Window.Gtk_Window_Record'Class is
   begin
      return Main_Win;
   end Get_Window;

   --------------
   -- Get_VBox --
   --------------

   function Get_VBox
     return not null access Gtk.Box.Gtk_Vbox_Record'Class is
   begin
      return Vbox;
   end Get_VBox;

end WaveFiles_Gtk;
