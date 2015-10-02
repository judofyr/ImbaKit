# Matches up with NSTextAlignment
TextLeft = 0
TextCenter = 1
TextRight = 2
TextJustified = 3

tag text < view
	useNodeClass 'ImbaTextNode'

	defineProp "TextAlign"

	def setChildren child
		if !(child isa String)
			throw Error.new("<text> only accepts text")

		dom.setText(child)
		self