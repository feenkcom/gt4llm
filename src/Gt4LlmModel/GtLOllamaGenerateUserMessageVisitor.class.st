Class {
	#name : #GtLOllamaGenerateUserMessageVisitor,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #api }
GtLOllamaGenerateUserMessageVisitor >> chatMessage: aMessage [

	^ self visitNode: aMessage computeContentBlockFromInputModels.
]

{ #category : #visiting }
GtLOllamaGenerateUserMessageVisitor >> visitGtLPrimitiveCompositeJsonGenericDataBlock: aDataBlock [

	^ aDataBlock jsonDataBlocks 
		collect: [ :dataBlock |
			dataBlock acceptVisitor: self ]
		as: Array.
]

{ #category : #visiting }
GtLOllamaGenerateUserMessageVisitor >> visitGtLPrimitiveJsonBareDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData.
	self assert: string isString.
	^ {
		'prompt' -> string.
		} asDictionary
]

{ #category : #visiting }
GtLOllamaGenerateUserMessageVisitor >> visitGtLPrimitiveJsonDataBlock: aDataBlock [
	"This is a bit of a hack at the moment.
	If the data block is just content, assume that the message is a simple string and just answer the content, otherwise answer the string serialisation."
	| prompt |

	prompt := aDataBlock jsonData 
		at: 'content'
		ifPresent: [ :string |
			self assert: string isString.
			string ]
		ifAbsent:
			[ NeoJSONWriter toStringPretty: aDataBlock jsonData ].
	^ { 'prompt' -> prompt } asDictionary.
]

{ #category : #visiting }
GtLOllamaGenerateUserMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [

	^ aDataBlock compositeJsonDataBlock acceptVisitor: self.
]

{ #category : #visiting }
GtLOllamaGenerateUserMessageVisitor >> visitNode: aUserMessage [

	^ aUserMessage acceptVisitor: self
]
