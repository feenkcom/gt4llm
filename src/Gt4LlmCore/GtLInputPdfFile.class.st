Class {
	#name : #GtLInputPdfFile,
	#superclass : #GtLInputAttachment,
	#category : #Gt4LlmCore
}

{ #category : #serialization }
GtLInputPdfFile >> serializeForOpenAIResponsesAPI [
	^ {'type' -> 'input_file'.
		'filename' -> self fileReference basename.
		'file_data' -> ('data:application/pdf;base64,' , self fileReference binaryContents base64Encoded)}
			asDictionary
]
