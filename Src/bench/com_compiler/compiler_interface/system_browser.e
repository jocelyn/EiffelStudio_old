indexing
	description: "Facilities for browsing through a system"
	date: "$Date$"
	revision: "$Revision$"

class
	SYSTEM_BROWSER

inherit
	IEIFFEL_SYSTEM_BROWSER_IMPL_STUB
		redefine
			system_classes,
			class_count,
			system_clusters,
			cluster_count,
			class_descriptor,
			feature_descriptor,
			cluster_descriptor,
			search_classes,
			search_features
		end

	SHARED_EIFFEL_PROJECT

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize structure.
		do
		end
		
feature -- Access

	system_classes: CLASS_ENUMERATOR is
			-- List of classes in system.
		local
			res: ARRAYED_LIST [IEIFFEL_CLASS_DESCRIPTOR_INTERFACE]
			classes: ARRAY [CLASS_C]
			class_desc: CLASS_DESCRIPTOR
			count, i: INTEGER
		do
			if Eiffel_project.initialized then
				classes := Eiffel_system.Workbench.system.classes.sorted_classes
				count := Eiffel_system.Workbench.system.classes.count
				create res.make (count)
				from
					i := 1
				until
					i > count
				loop
					create class_desc.make_with_class_i (classes.item (i).lace_class)
					res.extend (class_desc)
					i := i + 1
				end
				create Result.make (res)
			end
		end

	class_count: INTEGER is
			-- Number of classes in system.
		do
			if Eiffel_project.initialized then
				Result := Eiffel_system.Workbench.system.classes.count
			end
		end

	system_clusters: CLUSTER_ENUMERATOR is
			-- List of system's top-level clusters.
		local
			list: LINKED_LIST [CLUSTER_I]
			cluster_desc: CLUSTER_DESCRIPTOR
			res: ARRAYED_LIST [IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE]
		do
			if Eiffel_project.initialized then
				list := Eiffel_universe.clusters
				create res.make (list.count)
				from
					list.start
				until
					list.after
				loop
					if list.item.parent_cluster = Void then
						create cluster_desc.make_with_cluster_i (list.item)
						res.extend (cluster_desc)
					end
					list.forth
				end
				create Result.make (res)
			end
		end
		
	cluster_count: INTEGER is
			-- Number of top-level clusters in system.
		do
			if Eiffel_project.initialized then
				Result := system_clusters.count
			end
		end
		
feature -- Basic Operations

	cluster_descriptor (cluster_name: STRING): IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE is
			-- Cluster descriptor.
			-- Void if no matches.
		local
			ci: CLUSTER_I
		do
			if Eiffel_project.initialized and then cluster_name /= Void then
				ci := Eiffel_universe.cluster_of_name (cluster_name)
				if ci /= Void then
					create {CLUSTER_DESCRIPTOR} Result.make_with_cluster_i (ci)
				end
			end
		end

	class_descriptor (class_name1: STRING): IEIFFEL_CLASS_DESCRIPTOR_INTERFACE is
			-- Class descriptor.
			-- Void if no matches.
		local
			matching_classes: LINKED_LIST [CLASS_I]
		do
			if Eiffel_project.initialized and then class_name1 /= Void then
				matching_classes := Eiffel_universe.compiled_classes_with_name (class_name1)
				if not matching_classes.is_empty then
						--| FIXME What if matching_classes.count > 1 ?
					if matching_classes.first.compiled then
						create {CLASS_DESCRIPTOR} Result.make_with_class_i (matching_classes.first)
					end
				end
			end
		end

	feature_descriptor (class_name1: STRING; feature_name: STRING): IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE is
			-- Feature descriptor.
			-- Void if no matches.
		local
			class_desc: CLASS_DESCRIPTOR
		do
			if Eiffel_project.initialized then
				class_desc ?= class_descriptor (class_name1)
				if class_desc /= Void then
					Result := class_desc.feature_with_name (feature_name)
				end
			end
		end

	search_classes (a_string: STRING; is_substring: BOOLEAN): CLASS_ENUMERATOR is
			-- Search classes with names matching `a_string'.
			-- `a_string' [in].  
			-- `is_substring' [in].  
		local
			res: ARRAYED_LIST [IEIFFEL_CLASS_DESCRIPTOR_INTERFACE]
			matching_classes: LINKED_LIST [CLASS_I]
			classes: ARRAY [CLASS_C]
			class_desc: CLASS_DESCRIPTOR
			count, i: INTEGER
			matcher: KMP_MATCHER
		do
			if Eiffel_project.initialized and then a_string /= Void then
				if is_substring then
					classes := Eiffel_system.Workbench.system.classes.sorted_classes
					count := Eiffel_system.Workbench.system.classes.count
					create res.make (count)
					create matcher.make_empty
					matcher.disable_case_sensitive
					matcher.set_pattern (a_string)
					from
						i := 1
					until
						i > count
					loop
						matcher.set_text (classes.item (i).lace_class.name)
						if matcher.search_for_pattern then
							create class_desc.make_with_class_i (classes.item (i).lace_class)
							res.extend (class_desc)
						end
						i := i + 1
					end
				else
					matching_classes := Eiffel_universe.compiled_classes_with_name (a_string)
					create res.make (matching_classes.count)
					from
						matching_classes.start
					until
						matching_classes.after
					loop
						create class_desc.make_with_class_i (matching_classes.item)
						res.extend (class_desc)
						matching_classes.forth
					end
				end
				create Result.make (res)
			end
		end

	search_features (a_string: STRING; is_substring: BOOLEAN): FEATURE_ENUMERATOR is
			-- Search feature with names matching `a_string'.
			-- `a_string' [in].  
			-- `is_substring' [in].  
		local
			res: ARRAYED_LIST [IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE]
			classes: ARRAY [CLASS_C]
			feature_table: FEATURE_TABLE
			feature_i: FEATURE_I
			count, i: INTEGER
			matcher: KMP_MATCHER
			feature_desc: FEATURE_DESCRIPTOR
		do
			if Eiffel_project.initialized and then a_string /= Void then
				classes := Eiffel_system.Workbench.system.classes.sorted_classes
				count := Eiffel_system.Workbench.system.classes.count
				create res.make (count * 5)
				create matcher.make_empty
				matcher.disable_case_sensitive
				matcher.set_pattern (a_string)
				from
					i := 1
				until
					i > count
				loop
					feature_table := classes.item (i).feature_table
					if is_substring then
						from
							feature_table.start
						until
							feature_table.after
						loop
							feature_i := feature_table.item_for_iteration
							matcher.set_text (feature_i.feature_name)
							if matcher.search_for_pattern then
								create feature_desc.make_with_class_i_and_feature_i (classes.item (i).lace_class, feature_i)
								res.extend (feature_desc)
							end
							feature_table.forth
						end
					else
						feature_table.search (a_string)
						if feature_table.found_item /= Void then
							create feature_desc.make_with_class_i_and_feature_i (classes.item (i).lace_class, feature_table.found_item)
							res.extend (feature_desc)
						end
					end
					i := i + 1
				end
				create Result.make (res)
			end
		end
		
end -- class SYSTEM_BROWSER
