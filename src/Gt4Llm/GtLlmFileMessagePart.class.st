Class {
	#name : #GtLlmFileMessagePart,
	#superclass : #GtLlmMessagePart,
	#instVars : [
		'fileId',
		'file'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmFileMessagePart >> content [
	^ self fileId
]

{ #category : #accessing }
GtLlmFileMessagePart >> file [
	^ file
]

{ #category : #accessing }
GtLlmFileMessagePart >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLlmFileMessagePart >> fileId [
	^ fileId
]

{ #category : #accessing }
GtLlmFileMessagePart >> fileId: anObject [
	fileId := anObject
]

{ #category : #'as yet unclassified' }
GtLlmFileMessagePart >> serialize [
	^ {'type' -> 'image_file'.
		'image_file' -> {'file_id' -> self fileId} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmFileMessagePart >> serializeInline [
	^ {'type' -> 'image_url'.
		'image_url'
			-> {'url' -> ('data:image/png;base64,' , self file binaryContents base64Encoded)}
					asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmFileMessagePart >> type [
	^ 'File'
]
