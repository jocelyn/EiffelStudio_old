-- Error when the root class is in two different clusters
-- and none of them is specified in the ace file

class VD29

inherit

	CLUSTER_ERROR

feature

	second_cluster_name: STRING;

	set_second_cluster_name (s: STRING) is
		do
			second_cluster_name := s;
		end;

	root_class_name: STRING;

	set_root_class_name (s: STRING) is
		do
			root_class_name := s;
		end;

	build_explain is
		do
			put_string ("Class name: ");
			put_string (root_class_name);
			put_string ("%NFirst cluster: ");
			put_string (cluster.cluster_name);
			put_string ("%NSecond cluster: ");
			put_string (second_cluster_name);
			new_line
		end;

end
