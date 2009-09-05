module SimpleRRD
	class Print < Command
		#  PRINT:vname:format[:strftime]
		#
		#  Depending on the context, either the value component or the time
		#  component of a VDEF is printed using format. It is an error to specify
		#  a vname generated by a DEF or CDEF.  Any text in format is printed
		#  literally with one exception: The percent character introduces a
		#  formatter string. This string can be: 
		#  
		#  For printing values:
		#
		#		 %%  
		#				just prints a literal '%' character
		#
		# 	 %#.#le
		#		  	prints numbers like 1.2346e+04. The optional integers # denote
		#		  	field width and decimal precision.
		#
		#    %#.#lf 
		#	      prints numbers like 12345.6789, with optional field width and
		#	      precision.
		#
		#    %s  
		#	    	place this after %le, %lf or %lg. This will be replaced by the
		#	    	appropriate SI magnitude unit and the value will be scaled
		#	    	accordingly (123456 -> 123.456 k).
		#
		# 	 %S
		# 	 		is similar to %s. It does, however, use a previously defined
		# 	 		magnitude unit. If there is no such unit yet, it tries to define
		# 	 		one (just like %s) unless the value is zero, in which case the
		# 	 		magnitude unit stays undefined. Thus, formatter strings using %S
		# 	 		and no %s will all use the same magnitude unit except for zero
		# 	 		values.
		#
		#  If you PRINT a VDEF value, you can also print the time associated with
		#  it by appending the string :strftime to the format. Note that rrdtool
		#  uses the strftime function of your OSs C library. This means that the
		#  conversion specifier may vary. Check the manual page if you are
		#  uncertain.

		include TextAttribute
		include ValueAttribute

		def definition
			raise "Value required but not set" unless value
			raise "Text required but not set" unless text
			"PRINT:#{value.vname}:#{text}"
		end
	end

	class GPrint < Print
		# GPRINT:vname:format
		#
		# This is the same as "PRINT", but printed inside the graph.

		def definition
			raise "Value required but not set" unless value
			raise "Text required but not set" unless text
			"GPRINT:#{value.vname}:#{text}"
		end
	end

	class Comment < Command
		# COMMENT:text
		#
		# Text is printed literally in the legend section of the graph. Note that
		# in RRDtool 1.2 you have to escape colons in COMMENT text in the same way
		# you have to escape them in *PRINT commands by writing '\:'.

		include TextAttribute

		def definition
			raise "Text required but not set" unless text
			"COMMENT:#{text}"
		end
	end

	class Line < Command
		#  LINE[width]:value[#color][:[legend][:STACK]][:dashes[=on_s[,off_s[,on_s,off_s]...]][:dash-offset=offset]]
		#
		#  Draw a line of the specified width onto the graph. width can be a
		#  floating point number. If the color is not specified, the drawing is
		#  done 'invisibly'. This is useful when stacking something else on top of
		#  this line. Also optional is the legend box and string which will be
		#  printed in the legend section if specified. The value can be generated
		#  by DEF, VDEF, and CDEF.  If the optional STACK modifier is used, this
		#  line is stacked on top of the previous element which can be a LINE or
		#  an AREA.
		#
		#  The dashes modifier enables dashed line style. Without any further
		#  options a symmetric dashed line with a segment length of 5 pixels will
		#  be drawn. The dash pattern can be changed if the dashes= parameter is
		#  followed by either one value or an even number (1, 2, 4, 6, ...) of
		#  positive values. Each value provides the length of alternate on_s and
		#  off_s portions of the stroke. The dash-offset parameter specifies an
		#  offset into the pattern at which the stroke begins.
		#
		#  When you do not specify a color, you cannot specify a legend.  Should
		#  you want to use STACK, use the "LINEx:<value>::STACK" form.

		include TextAttribute
		include DataAttribute
		include ColorAttribute

		def initialize(opts = {})
			@width = 1
			@stack = false
			call_hash_methods(opts)
		end
		
		attr_reader :width, :stack

		def width=(n)
			w = n.to_i
			raise "Width must be a number >0 " unless w > 0
			@width = w
		end

		def stack=(bool)
			@stack = !!bool
		end

		def definition
			raise "Data required but not set" unless data
			raise "Text specified, but color set to :invisible" if text and color == :invisible
			ret = "LINE#{width}:#{data.vname}"
			ret << "\##{color}" unless color == :invisible
			ret << ":#{text}" if text
			ret << ":STACK" if stack
			return ret
		end
	end

	class Area < Command
		#  AREA:value[#color][:[legend][:STACK]]
		#
		#  See LINE, however the area between the x-axis and the line will be filled.
		include TextAttribute
		include DataAttribute
		include ColorAttribute

		def initialize(opts = {})
			@stack = false
			call_hash_methods(opts)
		end
		
		attr_reader :stack

		def stack=(bool)
			@stack = !!bool
		end

		def definition
			raise "Data required but not set" unless data
			raise "Text specified, but color set to :invisible" if text and color == :invisible
			ret = "AREA:#{data.vname}"
			ret << "\##{color}" unless color == :invisible
			ret << ":#{text}" if text
			ret << ":STACK" if stack
			return ret
		end
	end
end