indexing
	description: "Tool bar for docking library."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SD_TOOL_BAR

inherit
	SD_DRAWING_AREA
		export
			{NONE} all
			{ANY} width, height, minimum_width, minimum_height,
				 set_background_color, background_color, screen_x,
				  screen_y, hide, show, is_displayed,parent,
					pointer_motion_actions, pointer_button_release_actions,
					enable_capture, disable_capture, has_capture,
					x_position, y_position, destroy,
					set_minimum_width, set_minimum_height
			{SD_TOOL_BAR_DRAWER_I, SD_TOOL_BAR_ZONE, SD_TOOL_BAR} implementation, draw_pixmap, clear_rectangle
			{SD_TOOL_BAR_ITEM, SD_TOOL_BAR} tooltip, set_tooltip, remove_tooltip, font
			{SD_TOOL_BAR_DRAGGING_AGENTS, SD_TOOL_BAR_DOCKER_MEDIATOR, SD_TOOL_BAR} set_pointer_style
			{SD_TOOL_BAR_ZONE, SD_TOOL_BAR} expose_actions, pointer_button_press_actions, pointer_double_press_actions,
							redraw_rectangle
			{SD_NOTEBOOK_HIDE_TAB_DIALOG} key_press_actions, focus_out_actions, set_focus, has_focus
		redefine
			update_for_pick_and_drop
		end

create
	make

feature {NONE} -- Initlization

	make is
			-- Creation method
		do
			default_create
			create internal_shared
			internal_row_height := standard_height
			create internal_items.make (1)
			expose_actions.extend (agent on_expose)
			pointer_motion_actions.extend (agent on_pointer_motion)
			pointer_button_press_actions.extend (agent on_pointer_press)
			pointer_button_press_actions.extend (agent on_pointer_press_forwarding)
			pointer_double_press_actions.extend (agent on_pointer_press)
			pointer_button_release_actions.extend (agent on_pointer_release)
			pointer_leave_actions.extend (agent on_pointer_leave)
			pointer_enter_actions.extend (agent on_pointer_enter)

			drop_actions.extend (agent on_drop_action)
			drop_actions.set_veto_pebble_function (agent on_veto_pebble_function)

			set_background_color (internal_shared.default_background_color)
		end

feature -- Properties

	row_height: INTEGER is
			-- Height of row.
		do
			Result := internal_row_height
		ensure
			valid: is_row_height_valid (Result)
		end

feature -- Command

	extend (a_item: SD_TOOL_BAR_ITEM) is
			-- Extend `a_item' to the end.
		require
			not_void: a_item /= Void
			valid: is_item_valid (a_item)
		do
			internal_items.extend (a_item)
			a_item.set_tool_bar (Current)
		ensure
			has: has (a_item)
			is_parent_set: is_parent_set (a_item)
		end

	force (a_item: SD_TOOL_BAR_ITEM; a_index: INTEGER) is
			-- Assign item `a_item' to `a_index'-th entry.
			-- Always applicable: resize the array if `a_index' falls out of
			-- currently defined bounds; preserve existing items.
		require
			not_void: a_item /= Void
			valid: is_item_valid (a_item)
		do
			internal_items.go_i_th (a_index)
			internal_items.put_left (a_item)
			a_item.set_tool_bar (Current)
		end

	prune (a_item: SD_TOOL_BAR_ITEM) is
			-- Prune `a_item'
		do
			internal_items.prune_all (a_item)
			a_item.set_tool_bar (Void)
		ensure
			pruned: not has (a_item)
			parent_void: a_item.tool_bar = Void
		end

	compute_minimum_size is
			-- Compute `minmum_width' and `minimum_height'.
		local
			l_minimum_width: INTEGER
			l_minimum_height: INTEGER
			l_item: SD_TOOL_BAR_ITEM
			l_items: like internal_items
			l_separator: SD_TOOL_BAR_SEPARATOR
			l_item_before: SD_TOOL_BAR_ITEM
		do
			from
				l_items := items
				l_items.start
				if l_items.count > 0 then
					l_minimum_height := row_height
				end
			until
				l_items.after
			loop
				l_item := l_items.item
				l_separator ?= l_item
				if l_items.index = l_items.count or l_item.is_wrap then
					-- Minimum width only make sence in this case.
					if l_separator /= Void then
						-- It's a separator, we should calculate the item before
						if l_item_before /= Void then
							l_item := l_item_before
						end
					end
					if l_minimum_width < l_item.rectangle.right then
						l_minimum_width := l_item.rectangle.right
					end
				end
				if l_items.index = l_items.count then
					l_minimum_height := l_item.rectangle.bottom
				end

				l_item_before := l_items.item
				l_items.forth
			end
			debug ("docking")
				print ("%NSD_TOOL_BAR compute minimum size minimum_width is: " + l_minimum_width.out)
				print ("%NSD_TOOL_BAR compute minimum size minimum_height is: " + l_minimum_height.out)
				print ("%N             items.count: " + l_items.count.out)
			end

			set_minimum_width (l_minimum_width)
			set_minimum_height (l_minimum_height)
		end

	update_size is
			-- Update `tool_bar' size if Current width changed.
		local
			l_tool_bar_row: SD_TOOL_BAR_ROW
			l_parent: EV_CONTAINER
			l_floating_zone: SD_FLOATING_TOOL_BAR_ZONE
		do
			compute_minimum_size
			l_tool_bar_row ?= parent
			if l_tool_bar_row /= Void then
				l_tool_bar_row.set_item_size (Current, minimum_width, minimum_height)
			else
				-- If Current is in a SD_FLOATING_TOOL_BAR_ZONE which is a 3 level parent.
				l_parent := parent
				if l_parent /= Void then
					l_parent := l_parent.parent
					if l_parent /= Void then
						l_parent := l_parent.parent
						l_floating_zone ?= l_parent
						if l_floating_zone /= Void then
							l_floating_zone.set_size (l_floating_zone.minimum_width, l_floating_zone.minimum_height)
						end
					end
				end
			end
		end

	wipe_out is
			-- Wipe out
		do
			internal_items.wipe_out
		end

feature -- Query

	items: like internal_items is
			-- `internal_items''s snapshot.
		do
			Result := internal_items.twin
		ensure
			not_void: Result /= Void
		end

	has (a_item: SD_TOOL_BAR_ITEM): BOOLEAN is
			-- If Current has `a_item' ?
		do
			Result := internal_items.has (a_item)
		end

	border_width: INTEGER is
			-- Border width.
		local
			l_platform: PLATFORM
		once
			Result := (internal_shared.tool_bar_font.height / 2).floor

			create l_platform
			if l_platform.is_windows then
				Result := Result + 1
			end
		end

	padding_width: INTEGER is 4
			-- Padding width.

	standard_height: INTEGER is
			-- Standard tool bar height.
		do
			Result := internal_shared.tool_bar_font.height + 2 * border_width
		end

feature -- Contract support

	is_row_height_set (a_new_height: INTEGER): BOOLEAN is
			-- If row height set?
		do
			Result := internal_row_height = a_new_height
		end

	is_row_height_valid (a_height: INTEGER): BOOLEAN is
			-- If `a_height' valid?
		do
			Result := internal_row_height = a_height
		end

	is_parent_set (a_item: SD_TOOL_BAR_ITEM): BOOLEAN is
			-- If `a_item' parent set?
		do
			Result := a_item.tool_bar = Current
		end

	is_start_x_set (a_x: INTEGER): BOOLEAN is
			--
		do
			Result := start_x = a_x
		end

	is_start_y_set (a_y: INTEGER): BOOLEAN is
			--
		do
			Result := start_y = a_y
		end

	is_item_valid (a_item: SD_TOOL_BAR_ITEM): BOOLEAN is
			-- If `a_item' valid?
		local
			l_widget_item: SD_TOOL_BAR_WIDGET_ITEM
		do
			Result := True
			l_widget_item ?= a_item
			if l_widget_item /= Void then
				Result := l_widget_item.widget.parent = Void
			end
		end

	is_item_position_valid (a_screen_x, a_screen_y: INTEGER): BOOLEAN is
			-- If `a_screen_x' and `a_screen_y' within tool bar items area?
		do
			Result := a_screen_x >= screen_x and a_screen_y >= screen_y
								and a_screen_x < width + screen_x and a_screen_y < height + screen_y
		end

feature {SD_TOOL_BAR_DRAWER_IMP, SD_TOOL_BAR_ITEM, SD_TOOL_BAR} -- Internal issues

	item_x (a_item: SD_TOOL_BAR_ITEM): INTEGER is
			-- Relative x position of `a_item'.
		require
			has: has (a_item)
		local
			l_stop: BOOLEAN
			l_item: SD_TOOL_BAR_ITEM
			l_items: like internal_items
			l_separator: SD_TOOL_BAR_SEPARATOR
		do
			from
				Result := start_x
				l_items := items
				l_items.start
			until
				l_items.after or l_stop
			loop
				l_item := l_items.item
				if l_item /= a_item then
					if l_item.is_wrap then
						Result := start_x
					else
						Result := Result + l_item.width
					end
				else
					l_separator ?= l_item
					l_stop := True
					if l_separator /= Void and then l_separator.is_wrap then
						Result := start_x
					end
				end
				l_items.forth
			end
		end

	item_y (a_item: SD_TOOL_BAR_ITEM): INTEGER is
			-- Relative y position of `a_item'.
		require
			has: has (a_item)
		local
			l_stop: BOOLEAN
			l_item: SD_TOOL_BAR_ITEM
			l_separator: SD_TOOL_BAR_SEPARATOR
			l_items: like internal_items
		do
			from
				Result := start_y
				l_items := items
				l_items.start
			until
				l_items.after or l_stop
			loop
				l_item := l_items.item
				l_separator ?= l_item
				if l_item /= a_item then
					if l_item.is_wrap then
						Result := Result + l_item.height
					end
					if l_separator /= Void and then l_separator.is_wrap then
						Result := Result + l_separator.width
					end
				else
					l_stop := True
					if l_separator /= Void and then l_separator.is_wrap then
						Result := Result + l_item.height
					end
				end
				l_items.forth
			end
		end

	update is
			-- Redraw item(s) which `is_need_redraw'
		local
			l_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			l_rect: EV_RECTANGLE
			l_item: SD_TOOL_BAR_ITEM
		do
			if width /= 0 and height /= 0 then
				from
					l_items := items
					l_items.start
				until
					l_items.after
				loop
					-- item's tool bar query maybe Void, because it's hidden when not enough space to display.
					l_item := l_items.item
					if l_item.is_need_redraw and l_item.tool_bar /= Void then
						l_rect := l_item.rectangle
						drawer.start_draw (l_rect)
						redraw_item (l_item)
						drawer.end_draw
						l_item.disable_redraw
					end
					l_items.forth
				end
			end
		end

feature {SD_TOOL_BAR_ZONE, SD_TOOL_BAR} -- Tool bar zone issues

	set_start_x (a_x: INTEGER) is
			-- Set start x position with `a_x'.
		do
			internal_start_x := a_x
		ensure
			set: is_start_x_set (a_x)
		end

	set_start_y (a_y: INTEGER) is
			-- Set start y position with `a_y'.
		do
			internal_start_y := a_y
		ensure
			set: is_start_y_set (a_y)
		end

	start_x: INTEGER is
			-- `internal_start_x'
		do
			Result := internal_start_x
		end

	start_y: INTEGER is
			-- 'internal_start_y'
		do
			Result := internal_start_y
		end

feature {NONE} -- Agents

	on_expose (a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- Handle expose actions.
		local
			l_items: like internal_items
		do
			drawer.start_draw (create {EV_RECTANGLE}.make (a_x, a_y, a_width, a_height))
			from
				l_items := items
				l_items.start
			until
				l_items.after
			loop
				if l_items.item.has_rectangle (create {EV_RECTANGLE}.make (a_x, a_y, a_width, a_height)) then
					redraw_item (l_items.item)
				end
				l_items.forth
			end
			drawer.end_draw
		end

	on_pointer_motion (a_x: INTEGER; a_y: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER) is
			-- Handle pointer motion actions.
		local
			l_items: like internal_items
			l_item: SD_TOOL_BAR_ITEM
		do
			if pointer_entered then
				from
					l_items := items
					l_items.start
				until
					l_items.after
				loop
					l_item := l_items.item
					l_item.on_pointer_motion (a_x, a_y)
					l_item.on_pointer_motion_for_tooltip (a_x, a_y)
					if l_item.is_need_redraw then
						drawer.start_draw (l_item.rectangle)
						redraw_item (l_item)
						drawer.end_draw
					end
					l_items.forth
				end
			end
		end

	on_pointer_press (a_x: INTEGER; a_y: INTEGER; a_button: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER) is
			-- Handle pointer press actions.
		local
			l_items: like internal_items
			l_item: SD_TOOL_BAR_ITEM
		do
			debug ("docking")
				print ("%NSD_TOOL_BAR on_pointer_press")
			end
			if a_button = 1 then
				enable_capture
				from
					l_items := items
					l_items.start
				until
					l_items.after
				loop
					l_item := l_items.item
					l_item.on_pointer_press (a_x, a_y)
					if l_item.is_need_redraw then
						drawer.start_draw (l_item.rectangle)
						redraw_item (l_item)
						drawer.end_draw
					end
					l_items.forth
				end
			end
		end

	on_pointer_press_forwarding (a_x: INTEGER; a_y: INTEGER; a_button: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER) is
			-- Handle pointer press actions for forwarding.
		local
			l_items: like internal_items
		do
			from
				l_items := items
				l_items.start
			until
				l_items.after
			loop
				l_items.item.on_pointer_press_forwarding (a_x, a_y, a_button, a_x_tilt, a_y_tilt, a_pressure, a_screen_x, a_screen_y)
				l_items.forth
			end
		end

	on_pointer_release (a_x: INTEGER; a_y: INTEGER; a_button: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER) is
			-- Handle pointer release actions.
		local
			l_items: like internal_items
			l_item: SD_TOOL_BAR_ITEM
		do

			if a_button = 1 then
				disable_capture
				internal_pointer_pressed := False
				from
					l_items := items
					l_items.start
				until
					l_items.after
				loop
					l_item := l_items.item
					l_item.on_pointer_release (a_x, a_y)
					if l_item.is_need_redraw then
						drawer.start_draw (l_item.rectangle)
						redraw_item (l_item)
						drawer.end_draw
					end
					l_items.forth
				end
			end
		end

	on_pointer_enter is
			-- Handle poiner enter actions.
			-- Pointer enter actions and pointer leave actions always called in pairs.
			-- That means: `on_pointer_motion' actions can be called without `on_pointer_enter' be called.
			-- That will let tool bar item draw hot state (which is done by `pointer_motion_actions'), but no pointer leave actions to erase the hot state.
		do
			pointer_entered := True
		ensure
			set: pointer_entered = True
		end

	on_pointer_leave is
			-- Handle pointer leave actions.
		local
			l_items: like internal_items
			l_item: SD_TOOL_BAR_ITEM
		do
			from
				l_items := items
				l_items.start
			until
				l_items.after
			loop
				l_item := l_items.item
				l_item.on_pointer_leave
				if l_item.is_need_redraw then
					drawer.start_draw (l_item.rectangle)
					redraw_item (l_item)
					drawer.end_draw
				end
				l_items.forth
			end
			pointer_entered := False
		ensure
			set: pointer_entered = False
		end

	on_drop_action (a_any: ANY) is
			-- Handle drop actions.
		local
			l_screen: EV_SCREEN
			l_item: SD_TOOL_BAR_ITEM
			l_pointer_position: EV_COORDINATE
		do
			create l_screen
			l_pointer_position := l_screen.pointer_position
			l_item := item_at_position (l_pointer_position.x, l_pointer_position.y)
			if l_item /= Void then
				l_item.drop_actions.call ([a_any])
			end
		end

	on_veto_pebble_function (a_any: ANY): BOOLEAN is
			-- Handle veto pebble function.
		local
			l_screen: EV_SCREEN
			l_item: SD_TOOL_BAR_ITEM
			l_pointer_position: EV_COORDINATE
		do
			create l_screen
			l_pointer_position := l_screen.pointer_position
			if is_item_position_valid (l_pointer_position.x, l_pointer_position.y)  then
				l_item := item_at_position (l_pointer_position.x, l_pointer_position.y)
				if l_item /= Void then
					Result := l_item.drop_actions.accepts_pebble (a_any)
				end
			end
		end

feature {SD_TOOL_BAR} -- Implementation

	redraw_item (a_item: SD_TOOL_BAR_ITEM) is
			-- Redraw `a_item'.
		require
			not_void: a_item /= Void
		local
			l_argu: SD_TOOL_BAR_DRAWER_ARGUMENTS
			l_coordinate: EV_COORDINATE
			l_rectangle: EV_RECTANGLE
			l_item: SD_TOOL_BAR_WIDGET_ITEM
		do
			l_item ?= a_item
			if l_item = Void then
				l_rectangle := a_item.rectangle
				create l_argu.make
				l_argu.set_item (a_item)
				create l_coordinate
				l_coordinate.set_x (item_x (a_item))
				l_coordinate.set_y (item_y (a_item))
				l_argu.set_position (l_coordinate)
				l_argu.set_tool_bar (Current)

				drawer.draw_item (l_argu)
			end
		end

	update_for_pick_and_drop (a_starting: BOOLEAN; a_pebble: ANY) is
			-- Update items for pick and drop.
		local
			l_items: like items
		do
			from
				l_items := items
				l_items.start
			until
				l_items.after
			loop
				l_items.item.update_for_pick_and_drop (a_starting, a_pebble)
				l_items.forth
			end
			update
		end

	drawer: SD_TOOL_BAR_DRAWER is
			-- Drawer with responsibility for draw OS native looks.
		do
			Result := internal_shared.tool_bar_drawer
			Result.set_tool_bar (Current)
		end

	internal_items: ARRAYED_SET [SD_TOOL_BAR_ITEM]
			-- All tool bar items in Current.

	internal_pointer_pressed: BOOLEAN
			-- If pointer button pressed?

	item_at_position (a_screen_x, a_screen_y: INTEGER): SD_TOOL_BAR_ITEM is
			-- Item at `a_screen_x', `a_screen_y'
			-- Result may be void when there wraps.
		require
			in_position: is_item_position_valid (a_screen_x, a_screen_y)
		local
			l_x, l_y: INTEGER
			l_items: like internal_items
		do
			from
				l_x := a_screen_x - screen_x
				l_y := a_screen_y - screen_y
				l_items := internal_items
				l_items.start
			until
				l_items.after or Result /= Void
			loop
				Result := l_items.item
				if not Result.rectangle.has_x_y (l_x, l_y) then
					Result := Void
				end
				l_items.forth
			end
		end

	pointer_entered: BOOLEAN
			-- Has pointer enter actions been called?
			-- The reason why have this flag see `on_pointer_enter''s comments.

	internal_shared: SD_SHARED
			-- All singletons.

	internal_row_height: INTEGER
			-- Row height of Current.

	internal_start_x: INTEGER
			-- X postion start to draw buttons.

	internal_start_y: INTEGER
			-- Y postion start to draw buttons.

invariant
	not_void: items /= Void
	not_void: internal_items /= Void

indexing
	library:	"SmartDocking: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end
