Class {
	#name : #GtOpenAIFilesGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFilesGroup class >> itemClass [
	^ GtOpenAIFile
]
