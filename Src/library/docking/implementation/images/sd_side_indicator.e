indexing
	description: "This class is generated by PNGEiffelCode"

class
	SD_SIDE_INDICATOR

inherit
	EV_PIXMAP

create
	make_top_to_bottom,
	make_left_to_right,
	make_bottom_to_top,
	make_right_to_left

feature {NONE} -- Initialization

	make_top_to_bottom (discard_color: EV_COLOR) is
			-- Initialization
		do
			make_with_size (32, 32)
			discard_color_internal := discard_color
			draw_direction := 1
			draw
		end

	make_left_to_right (discard_color: EV_COLOR) is
			-- Initialization
		do
			make_with_size (32, 32)
			discard_color_internal := discard_color
			draw_direction := 2
			draw
		end

	make_bottom_to_top (discard_color: EV_COLOR) is
			-- Initialization
		do
			make_with_size (32, 32)
			discard_color_internal := discard_color
			draw_direction := 3
			draw
		end

	make_right_to_left (discard_color: EV_COLOR) is
			-- Initialization
		do
			make_with_size (32, 32)
			discard_color_internal := discard_color
			draw_direction := 4
			draw
		end

feature {NONE} -- Implementation

	draw is
			-- Draw current.
		local
			i, j, t_count, colors_count, max_len: INTEGER
		do
			build_colors

			colors_count := colors.count
			max_len := width.max (height)
			from
				j := 0
			until
				j >= colors_count
			loop
				from
					i := 0
					t_count := colors.item (j).count // 3
				until
					i >= t_count
				loop
					if discard_color_internal /= Void implies not (colors.item (j).item (3 * i) = discard_color_internal.red_8_bit and colors.item (j).item (3 * i + 1) = discard_color_internal.green_8_bit and colors.item (j).item (3 * i + 2) = discard_color_internal.blue_8_bit) then
						set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (colors.item (j).item (3 * i), colors.item (j).item (3 * i + 1), colors.item (j).item (3 * i + 2)))
						inspect draw_direction
						when 1 then
								-- Draw top to bottom.
							draw_point (i, j)
						when 2 then
								-- Draw left to right.
							draw_point (j, max_len - i - 1)
						when 3 then
								-- Draw bottom to top.
							draw_point (t_count - i - 1, colors_count - j + 1)
						when 4 then
								-- Draw right to left.
							draw_point (colors_count - j + 1, i)
						end
					end
					i := i + 1
				end
				j := j + 1
			end
			colors := Void
		end

	build_colors is
			-- Build `colors'.
		local
			l_helper: SD_COLOR_HELPER
			l_shared: SD_SHARED
		do
			create colors.make (32)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 255, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 0)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 251, 252, 253, 242, 244, 247, 189, 204, 227, 187, 202, 226, 242, 245, 248, 248, 249, 251, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 1)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 250, 251, 252, 200, 213, 231, 39, 93, 173, 1, 64, 161, 1, 64, 161, 39, 93, 174, 201, 214, 231, 248, 249, 251, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 2)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 251, 252, 253, 250, 251, 252, 197, 210, 229, 21, 79, 167, 1, 66, 163, 1, 83, 184, 1, 83, 184, 1, 66, 163, 21, 80, 167, 198, 212, 230, 249, 250, 252, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 3)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 254, 248, 249, 251, 195, 209, 228, 21, 80, 168, 1, 67, 164, 1, 83, 184, 1, 83, 184, 1, 83, 184, 1, 83, 184, 1, 67, 164, 21, 79, 167, 198, 211, 230, 251, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 4)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 254, 247, 249, 250, 197, 210, 229, 21, 79, 167, 1, 67, 164, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 67, 164, 21, 80, 167, 199, 212, 230, 249, 250, 251, 252, 253, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 5)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 252, 253, 253, 195, 209, 228, 21, 80, 167, 1, 67, 164, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 83, 185, 1, 67, 164, 21, 80, 167, 199, 212, 230, 251, 252, 253, 251, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 6)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 251, 252, 253, 250, 251, 252, 197, 210, 230, 22, 80, 168, 2, 67, 164, 2, 84, 185, 2, 85, 186, 2, 85, 186, 2, 85, 186, 2, 86, 187, 2, 86, 187, 2, 85, 186, 2, 85, 186, 2, 85, 186, 2, 84, 185, 2, 67, 164, 22, 79, 167, 197, 210, 229, 248, 249, 251, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 7)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 250, 251, 252, 200, 213, 232, 21, 81, 169, 3, 68, 166, 4, 86, 187, 4, 87, 188, 4, 87, 188, 4, 88, 189, 4, 89, 190, 4, 89, 190, 4, 89, 190, 4, 89, 190, 4, 88, 189, 4, 87, 188, 4, 87, 188, 4, 86, 187, 3, 68, 166, 22, 81, 169, 195, 209, 228, 247, 248, 250, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 8)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 254, 248, 249, 251, 199, 212, 231, 23, 81, 170, 4, 70, 166, 6, 88, 188, 6, 88, 189, 6, 89, 189, 6, 90, 190, 6, 91, 191, 6, 92, 192, 6, 92, 192, 6, 92, 192, 6, 92, 192, 6, 91, 191, 6, 90, 190, 6, 89, 189, 6, 88, 189, 6, 88, 188, 4, 70, 166, 24, 81, 170, 198, 211, 230, 249, 250, 251, 253, 253, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 9)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 255, 251, 252, 253, 199, 212, 231, 24, 83, 171, 6, 71, 168, 8, 90, 190, 8, 91, 191, 8, 92, 192, 8, 93, 193, 8, 94, 194, 9, 96, 195, 9, 97, 196, 9, 97, 196, 9, 97, 196, 9, 97, 196, 9, 96, 195, 8, 94, 194, 8, 93, 193, 8, 92, 192, 8, 91, 191, 8, 90, 190, 6, 71, 168, 24, 83, 171, 200, 213, 231, 251, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 10)
			colors.put (<<255, 255, 255, 255, 255, 255, 254, 254, 255, 250, 251, 252, 198, 211, 230, 26, 85, 172, 7, 74, 169, 10, 94, 191, 10, 94, 192, 11, 95, 193, 11, 97, 194, 12, 98, 196, 12, 100, 197, 13, 102, 198, 13, 103, 199, 13, 103, 200, 13, 103, 200, 13, 103, 199, 13, 102, 198, 12, 100, 197, 12, 98, 196, 11, 97, 194, 11, 95, 193, 10, 94, 192, 10, 94, 191, 7, 74, 169, 27, 85, 172, 197, 210, 230, 247, 248, 250, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 11)
			colors.put (<<255, 255, 255, 254, 254, 255, 247, 248, 250, 198, 211, 230, 26, 87, 174, 8, 75, 171, 11, 96, 193, 12, 97, 194, 12, 98, 195, 13, 100, 196, 13, 102, 198, 14, 104, 200, 14, 105, 201, 15, 107, 202, 15, 108, 203, 16, 109, 204, 16, 109, 204, 15, 108, 203, 15, 107, 202, 14, 105, 201, 14, 104, 200, 13, 102, 198, 13, 100, 196, 12, 98, 195, 12, 97, 194, 11, 96, 193, 8, 75, 171, 26, 87, 174, 198, 211, 230, 252, 253, 253, 251, 252, 253, 255, 255, 255>>, 12)
			colors.put (<<255, 255, 255, 247, 249, 250, 200, 213, 232, 28, 88, 175, 10, 77, 173, 15, 99, 195, 15, 99, 196, 16, 101, 197, 16, 103, 199, 17, 105, 200, 18, 107, 202, 19, 109, 204, 20, 111, 205, 20, 112, 206, 21, 113, 207, 21, 113, 208, 21, 113, 208, 21, 113, 207, 20, 112, 206, 20, 111, 205, 19, 109, 204, 18, 107, 202, 17, 105, 200, 16, 103, 199, 16, 101, 197, 15, 99, 196, 15, 99, 195, 10, 77, 173, 28, 88, 176, 199, 212, 231, 253, 253, 254, 255, 255, 255>>, 13)
			colors.put (<<255, 255, 255, 238, 242, 246, 41, 99, 179, 11, 79, 173, 17, 102, 196, 17, 103, 197, 18, 105, 199, 18, 106, 200, 20, 109, 202, 21, 111, 204, 22, 114, 206, 22, 115, 207, 23, 117, 208, 24, 118, 209, 24, 119, 210, 24, 119, 210, 24, 119, 210, 24, 119, 210, 24, 118, 209, 23, 117, 208, 22, 115, 207, 22, 114, 206, 21, 111, 204, 20, 109, 202, 18, 106, 200, 18, 105, 199, 17, 103, 197, 17, 102, 196, 11, 79, 173, 41, 99, 179, 234, 238, 243, 255, 255, 255>>, 14)
			colors.put (<<250, 251, 252, 190, 206, 230, 12, 79, 172, 20, 104, 199, 20, 105, 200, 21, 107, 201, 22, 109, 203, 23, 112, 205, 25, 115, 207, 26, 117, 209, 27, 119, 211, 28, 121, 212, 28, 122, 213, 29, 123, 214, 29, 123, 214, 29, 123, 214, 29, 123, 214, 29, 123, 214, 29, 123, 214, 28, 122, 213, 28, 121, 212, 27, 119, 211, 26, 117, 209, 25, 115, 207, 23, 112, 205, 22, 109, 203, 21, 107, 201, 20, 105, 200, 20, 104, 199, 12, 79, 172, 185, 203, 227, 254, 254, 254>>, 15)
			colors.put (<<250, 251, 252, 188, 205, 228, 15, 81, 174, 23, 109, 202, 24, 111, 203, 25, 114, 205, 27, 117, 207, 28, 120, 210, 30, 122, 212, 31, 125, 214, 32, 126, 215, 32, 128, 216, 33, 129, 217, 33, 129, 217, 33, 129, 217, 33, 129, 217, 33, 129, 217, 33, 129, 217, 33, 129, 217, 33, 129, 217, 32, 128, 216, 32, 126, 215, 31, 125, 214, 30, 122, 212, 28, 120, 210, 27, 117, 207, 25, 114, 205, 24, 111, 203, 23, 109, 202, 15, 81, 174, 186, 203, 228, 252, 253, 253>>, 16)
			colors.put (<<255, 255, 255, 237, 240, 245, 44, 103, 183, 18, 89, 180, 28, 118, 207, 30, 121, 210, 32, 125, 212, 33, 128, 215, 34, 130, 216, 36, 132, 218, 36, 134, 219, 37, 134, 220, 37, 135, 220, 37, 135, 220, 37, 135, 220, 37, 135, 220, 37, 135, 220, 37, 135, 220, 37, 135, 220, 37, 135, 220, 37, 134, 220, 36, 134, 219, 36, 132, 218, 34, 130, 216, 33, 128, 215, 32, 125, 212, 30, 121, 210, 28, 118, 207, 18, 89, 180, 45, 104, 183, 239, 242, 246, 255, 255, 255>>, 17)
			colors.put (<<254, 254, 255, 251, 252, 253, 200, 214, 233, 38, 101, 183, 22, 94, 183, 35, 129, 215, 37, 132, 217, 38, 135, 219, 39, 137, 221, 40, 139, 222, 41, 139, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 140, 223, 41, 139, 223, 40, 139, 222, 39, 137, 221, 38, 135, 219, 37, 132, 217, 35, 129, 215, 22, 94, 183, 38, 101, 183, 199, 214, 232, 249, 250, 251, 255, 255, 255>>, 18)
			colors.put (<<255, 255, 255, 255, 255, 255, 251, 252, 253, 201, 215, 233, 42, 106, 185, 27, 100, 186, 42, 139, 221, 43, 142, 223, 44, 144, 224, 45, 144, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 145, 225, 45, 144, 225, 44, 144, 224, 43, 142, 223, 42, 139, 221, 27, 100, 186, 42, 106, 185, 200, 215, 232, 250, 251, 252, 253, 253, 254, 255, 255, 255>>, 19)
			colors.put (<<255, 255, 255, 255, 255, 255, 253, 253, 254, 251, 252, 253, 202, 216, 234, 46, 110, 187, 32, 106, 189, 47, 148, 227, 48, 149, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 150, 228, 48, 149, 228, 47, 148, 227, 32, 106, 189, 46, 110, 187, 197, 212, 231, 250, 251, 252, 254, 254, 254, 255, 255, 255, 255, 255, 255>>, 20)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 251, 252, 253, 199, 214, 233, 49, 115, 190, 35, 111, 193, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 52, 155, 231, 35, 111, 193, 49, 115, 190, 201, 217, 233, 247, 248, 250, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 21)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 255, 250, 251, 252, 198, 214, 231, 52, 118, 192, 38, 114, 194, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 56, 159, 233, 38, 114, 194, 52, 118, 192, 199, 214, 232, 248, 249, 251, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 22)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 252, 253, 253, 252, 253, 253, 202, 217, 234, 53, 120, 193, 39, 118, 196, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 58, 164, 235, 39, 118, 196, 54, 120, 193, 199, 214, 232, 251, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 23)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 249, 250, 252, 200, 216, 233, 55, 123, 194, 41, 120, 198, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 61, 167, 237, 41, 120, 198, 55, 123, 195, 203, 217, 234, 251, 252, 253, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 24)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 252, 253, 253, 251, 252, 253, 200, 216, 234, 56, 125, 196, 43, 122, 199, 64, 170, 239, 64, 170, 239, 64, 170, 239, 64, 170, 239, 64, 170, 239, 64, 170, 239, 64, 170, 239, 64, 170, 239, 43, 122, 199, 56, 125, 195, 200, 216, 234, 246, 247, 250, 251, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 25)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 254, 247, 248, 250, 199, 215, 232, 57, 126, 196, 44, 123, 200, 65, 172, 240, 65, 172, 240, 65, 172, 240, 65, 172, 240, 65, 172, 240, 65, 172, 240, 44, 123, 200, 57, 126, 196, 201, 216, 234, 252, 253, 253, 253, 253, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 26)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 254, 249, 250, 251, 201, 217, 234, 57, 126, 196, 44, 123, 200, 65, 172, 240, 65, 172, 240, 65, 172, 240, 65, 172, 240, 44, 123, 200, 57, 126, 196, 199, 215, 232, 247, 248, 250, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 27)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 255, 249, 250, 251, 203, 219, 235, 57, 126, 197, 44, 123, 200, 65, 172, 240, 65, 172, 240, 44, 123, 200, 57, 126, 196, 201, 217, 234, 246, 247, 250, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 28)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 254, 254, 248, 249, 251, 202, 218, 235, 72, 135, 200, 40, 115, 193, 40, 115, 193, 72, 135, 200, 202, 218, 235, 246, 247, 250, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 29)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 251, 252, 253, 249, 250, 252, 240, 244, 248, 194, 213, 233, 192, 211, 232, 235, 240, 245, 251, 252, 253, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 30)
			colors.put (<<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 250, 251, 252, 251, 252, 253, 255, 255, 255, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255>>, 31)
			create l_shared
			create l_helper
			l_helper.colorize_with (l_shared.focused_color, colors)
		end

	draw_direction : INTEGER

	colors: SPECIAL [SPECIAL [INTEGER]]

	discard_color_internal: EV_COLOR


end -- ARROW
