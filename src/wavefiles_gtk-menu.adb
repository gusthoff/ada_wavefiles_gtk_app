-------------------------------------------------------------------------------
--
--                        WAVEFILES GTK APPLICATION
--
--                            Application menu
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

with Gtk.Menu;
with Gtk.Menu_Bar;
with Gtk.Menu_Item;
with Gtk.Handlers;
with Gdk.Event;
with Gtk.File_Chooser_Dialog;
with Gtk.File_Chooser;
with Gtk.Dialog;
with Gtk.Widget;
with Gtk.About_Dialog;
with Gtk.File_Filter;

with WaveFiles_Gtk.Wavefile_List;

package body WaveFiles_Gtk.Menu is

   package Item_Handler is new Gtk.Handlers.Return_Callback
     (Gtk.Menu_Item.Gtk_Menu_Item_Record, Boolean);

   function Open_File
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Event     : Gdk.Event.Gdk_Event)
      return Boolean;

   function Quit_App
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Event     : Gdk.Event.Gdk_Event)
      return Boolean;

   function About_App
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Event     : Gdk.Event.Gdk_Event)
      return Boolean;

   ---------------
   -- Open_File --
   ---------------

   function Open_File
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Event     : Gdk.Event.Gdk_Event)
      return Boolean
   is
      pragma Unreferenced (Menu_Item, Event);

      Dialog : Gtk.File_Chooser_Dialog.Gtk_File_Chooser_Dialog;
      Filter : Gtk.File_Filter.Gtk_File_Filter;
      Button : Gtk.Widget.Gtk_Widget;
      pragma Unreferenced (Button);

      use type Gtk.Dialog.Gtk_Response_Type;
   begin

      Gtk.File_Chooser_Dialog.Gtk_New (Dialog => Dialog,
                                       Title  => "Select input wavefile",
                                       Parent => WaveFiles_Gtk.Get_Window,
                                       Action => Gtk.File_Chooser.Action_Open);

      Button := Dialog.Add_Button ("OK", Gtk.Dialog.Gtk_Response_OK);
      Button := Dialog.Add_Button ("Cancel", Gtk.Dialog.Gtk_Response_Cancel);

      Gtk.File_Filter.Gtk_New (Filter);
      Filter.Set_Name ("Wavefiles");
      Filter.Add_Mime_Type ("audio/wav");
      Dialog.Add_Filter (Filter);

      if Dialog.Run = Gtk.Dialog.Gtk_Response_OK then
         WaveFiles_Gtk.Wavefile_List.Insert (Dialog.Get_Filename);
      end if;

      Dialog.Destroy;
      return True;
   end Open_File;

   --------------
   -- Quit_App --
   --------------

   function Quit_App
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Event     : Gdk.Event.Gdk_Event)
      return Boolean is
      pragma Unreferenced (Menu_Item, Event);
   begin
      WaveFiles_Gtk.Destroy_Window;
      return True;
   end Quit_App;

   ---------------
   -- About_App --
   ---------------

   function About_App
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      Event     : Gdk.Event.Gdk_Event)
      return Boolean is
      pragma Unreferenced (Menu_Item, Event);

      Dialog : Gtk.About_Dialog.Gtk_About_Dialog;
      R      : Gtk.Dialog.Gtk_Response_Type;
      pragma Unreferenced (R);
   begin
      Dialog := Gtk.About_Dialog.Gtk_About_Dialog_New;
      Dialog.Set_Transient_For (WaveFiles_Gtk.Get_Window);
      Dialog.Set_Modal (True);

      R := Dialog.Run;
      Dialog.Destroy;
      return True;
   end About_App;

   ------------
   -- Create --
   ------------

   procedure Create is
      Menu_Bar     : Gtk.Menu_Bar.Gtk_Menu_Bar;
      Menu         : Gtk.Menu.Gtk_Menu;
      Menu_Item    : Gtk.Menu_Item.Gtk_Menu_Item;
      Menu_Subitem : Gtk.Menu_Item.Gtk_Menu_Item;

   begin
      Gtk.Menu_Bar.Gtk_New (Menu_Bar);
      WaveFiles_Gtk.Get_VBox.Pack_Start (Menu_Bar, False, False, 0);

      Gtk.Menu_Item.Gtk_New (Menu_Item, "File");
      Gtk.Menu.Gtk_New (Menu);

      Gtk.Menu_Item.Gtk_New (Menu_Subitem, "Open File...");
      Item_Handler.Connect
        (Widget    => Menu_Subitem,
         Name      => "button_press_event",
         Marsh     => Item_Handler.To_Marshaller (Open_File'Access),
         After     => False);
      Menu.Append (Menu_Subitem);

      Gtk.Menu_Item.Gtk_New (Menu_Subitem, "Quit");
      Item_Handler.Connect
        (Widget    => Menu_Subitem,
         Name      => "button_press_event",
         Marsh     => Item_Handler.To_Marshaller (Quit_App'Access),
         After     => False);
      Menu.Append (Menu_Subitem);

      Menu_Item.Set_Submenu (Menu);
      Menu_Bar.Append (Menu_Item);

      Gtk.Menu_Item.Gtk_New (Menu_Item, "Help");
      Gtk.Menu.Gtk_New (Menu);

      Gtk.Menu_Item.Gtk_New (Menu_Subitem, "About...");
      Item_Handler.Connect
        (Widget    => Menu_Subitem,
         Name      => "button_press_event",
         Marsh     => Item_Handler.To_Marshaller (About_App'Access),
         After     => False);
      Menu.Append (Menu_Subitem);

      Menu_Item.Set_Submenu (Menu);
      Menu_Bar.Append (Menu_Item);

   end Create;

end WaveFiles_Gtk.Menu;
