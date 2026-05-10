Class {
	#name : #GtLOllamaCompletionsMessageVisitor,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #api }
GtLOllamaCompletionsMessageVisitor >> chatMessage: aMessage [
	| content |
	
	content := self visitNode: aMessage "computeContentBlockFromInputModels".
	^ {
		'role' -> aMessage role.
		'content' -> content.
	} asDictionary.
]

{ #category : #visiting }
GtLOllamaCompletionsMessageVisitor >> visitGtLModelAssistantMessage: anAssistantMessage [

	^ { {
		'type' -> 'text'.
		'text' -> anAssistantMessage contentText 
		} asDictionary.
		}
]

{ #category : #visiting }
GtLOllamaCompletionsMessageVisitor >> visitGtLModelUserMessage: aUserMessage [

	^ aUserMessage computeContentBlockFromInputModels acceptVisitor: self
]

{ #category : #visiting }
GtLOllamaCompletionsMessageVisitor >> visitGtLPrimitiveCompositeJsonGenericDataBlock: aDataBlock [
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
GtLOllamaCompletionsMessageVisitor >> visitGtLPrimitiveJsonBareDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData.
	self assert: string isString.
	^ string
]

{ #category : #visiting }
GtLOllamaCompletionsMessageVisitor >> visitGtLPrimitiveJsonDataBlock: aDataBlock [
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
GtLOllamaCompletionsMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [
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
GtLOllamaCompletionsMessageVisitor >> visitNode: aUserMessage [

	^ aUserMessage acceptVisitor: self
]
