Class {
	#name : #GtLOllamaCompletionsUserMessageVisitor,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #api }
GtLOllamaCompletionsUserMessageVisitor >> userMessageWith: aMessage [
	| content |
	
	content := self visitNode: aMessage computeContentBlockFromInputModels.
	^ {
		'role' -> 'user'.
		'content' -> content.
	} asDictionary.
]

{ #category : #visiting }
GtLOllamaCompletionsUserMessageVisitor >> visitGtLPrimitiveCompositeJsonGenericDataBlock: aDataBlock [
	| content |

	content := aDataBlock jsonDataBlocks 
			collect: [ :dataBlock |
				dataBlock acceptVisitor: self ]
			as: Array.

	^ aDataBlock dataKey ifNil:
		[ content ]
	ifNotNil:
		[ { aDataBlock dataKey -> content } asDictionary ]
]

{ #category : #visiting }
GtLOllamaCompletionsUserMessageVisitor >> visitGtLPrimitiveJsonBareDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData.
	self assert: string isString.
	^ string
]

{ #category : #visiting }
GtLOllamaCompletionsUserMessageVisitor >> visitGtLPrimitiveJsonDataBlock: aDataBlock [
	"This is a bit of a hack at the moment.
	If the data block is just content, assume that the message is a simple string and just answer the content, otherwise answer the string serialisation."

	^ aDataBlock jsonData 
		at: 'content'
		ifPresent: [ :string |
			self assert: string isString.
			string ]
		ifAbsent:
			[ NeoJSONWriter toStringPretty: aDataBlock jsonData ].
]

{ #category : #visiting }
GtLOllamaCompletionsUserMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [
	| content text |

	content := OrderedCollection new.
	text := String crlf join: 
(aDataBlock compositeJsonDataBlock acceptVisitor: self).
	content add: {
		'type' -> 'text'.
		'text' -> (NeoJSONWriter toStringPretty: text)
		} asDictionary.
	aDataBlock imageDataBlocks do: [ :dataBlock |
		content add: {
			'type' -> 'image_url'.
			'image_url' -> ('data:image/', dataBlock imageType, ';base64,', dataBlock encodedBytes).
			} asDictionary. ].
	^ content asArray.
]

{ #category : #visiting }
GtLOllamaCompletionsUserMessageVisitor >> visitNode: aUserMessage [

	^ aUserMessage acceptVisitor: self
]
