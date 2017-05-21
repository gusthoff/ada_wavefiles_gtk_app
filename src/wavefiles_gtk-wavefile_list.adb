-------------------------------------------------------------------------------
--
--                        WAVEFILES GTK APPLICATION
--
--                           List of wavefiles
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

with Glib;
with Gtk.Enums;
with Gtk.Tree_Store;
with Gtk.Tree_View;
with Gtk.Tree_View_Column;
with Gtk.Cell_Renderer_Text;
with Gtk.Scrolled_Window;
with Gtk.Tree_Model;
with Glib.Values;
with Gtk.Tree_Selection;

with WaveFiles_Gtk.Wavefile_Manager;

package body WaveFiles_Gtk.Wavefile_List is

   procedure On_Selection
     (Self : access Gtk.Tree_Selection.Gtk_Tree_Selection_Record'Class);

   Wavefile_Tree           : Gtk.Tree_View.Gtk_Tree_View;
   Wavefile_Tree_Selection : Gtk.Tree_Selection.Gtk_Tree_Selection;
   Wavefiles_Tree_Model    : Gtk.Tree_Store.Gtk_Tree_Store;
   Scrolled                : Gtk.Scrolled_Window.Gtk_Scrolled_Window;
   Wavefile_Column         : constant := 0;

   ------------------
   -- On_Selection --
   ------------------

   procedure On_Selection
     (Self : access Gtk.Tree_Selection.Gtk_Tree_Selection_Record'Class)
   is
      Model       : Gtk.Tree_Model.Gtk_Tree_Model;
      Iter        : Gtk.Tree_Model.Gtk_Tree_Iter;
      Value       : Glib.Values.GValue;
   begin
      Self.Get_Selected (Model, Iter);
      Wavefiles_Tree_Model.Get_Value (Iter, Wavefile_Column, Value);
      declare
         Wavefile : constant String := Glib.Values.Get_String (Value);
      begin
         WaveFiles_Gtk.Set_Wavefile_Info
           (WaveFiles_Gtk.Wavefile_Manager.Get_Info (Wavefile));
      end;
   end On_Selection;

   ------------
   -- Create --
   ------------

   procedure Create (Vbox : Gtk.Box.Gtk_Vbox)
   is
      Col         : Gtk.Tree_View_Column.Gtk_Tree_View_Column;
      Text_Render : Gtk.Cell_Renderer_Text.Gtk_Cell_Renderer_Text;
      Num         : Glib.Gint;
      pragma Unreferenced (Num);

      use Gtk.Tree_Store;
   begin
      Gtk.Tree_Store.Gtk_New (Wavefiles_Tree_Model,
                              (Wavefile_Column => Glib.GType_String));

      Gtk.Tree_View.Gtk_New (Wavefile_Tree, +Wavefiles_Tree_Model);

      Wavefile_Tree.Set_Grid_Lines (Gtk.Enums.Grid_Lines_Vertical);
      Wavefile_Tree.Set_Enable_Tree_Lines (True);
      Wavefile_Tree.Set_Rubber_Banding (True);

      Gtk.Cell_Renderer_Text.Gtk_New (Text_Render);
      Gtk.Tree_View_Column.Gtk_New (Col);
      Col.Set_Resizable (True);
      Num := Wavefile_Tree.Append_Column (Col);

      Col.Set_Sort_Column_Id (Wavefile_Column);
      Col.Set_Title ("Wavefiles");
      Col.Pack_Start (Text_Render, True);

      Col.Add_Attribute (Text_Render, "text", Wavefile_Column);

      Wavefile_Tree.Set_Headers_Clickable (True);
      Wavefile_Tree_Selection := Wavefile_Tree.Get_Selection;
      Wavefile_Tree_Selection.On_Changed (On_Selection'Access);

      Gtk.Scrolled_Window.Gtk_New (Scrolled);
      Scrolled.Set_Policy (Gtk.Enums.Policy_Always,
                           Gtk.Enums.Policy_Always);
      Scrolled.Add (Wavefile_Tree);
      Scrolled.Show_All;

      Vbox.Pack_Start (Scrolled, True, True, 0);
   end Create;

   ------------
   -- Insert --
   ------------

   procedure Insert (Wavefile : String) is
      Parent, Iter : Gtk.Tree_Model.Gtk_Tree_Iter;
      Values       : Glib.Values.GValue_Array
        (Wavefile_Column .. Wavefile_Column);
   begin
      Parent := Gtk.Tree_Model.Null_Iter;
      Wavefiles_Tree_Model.Append (Iter, Parent);
      Glib.Values.Init_Set_String (Values (Wavefile_Column), Wavefile);

      Wavefiles_Tree_Model.Set (Iter, Values);
   end Insert;

end WaveFiles_Gtk.Wavefile_List;
