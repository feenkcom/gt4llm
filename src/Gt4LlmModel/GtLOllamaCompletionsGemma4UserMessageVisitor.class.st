Class {
	#name : #GtLOllamaCompletionsGemma4UserMessageVisitor,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #api }
GtLOllamaCompletionsGemma4UserMessageVisitor >> userMessageWith: aMessage [
	| content |
	
	content := self visitNode: aMessage computeContentBlockFromInputModels.
	^ {
		'role' -> 'user'.
		'content' -> content.
	} asDictionary.
]

{ #category : #visiting }
GtLOllamaCompletionsGemma4UserMessageVisitor >> visitGtLPrimitiveCompositeJsonGenericDataBlock: aDataBlock [
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
GtLOllamaCompletionsGemma4UserMessageVisitor >> visitGtLPrimitiveJsonBareDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData.
	self assert: string isString.
	^ string
]

{ #category : #visiting }
GtLOllamaCompletionsGemma4UserMessageVisitor >> visitGtLPrimitiveJsonDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData at: 'content'.
	self assert: string isString.
	"^ {
		'type' -> 'text'.
		'text' -> string.
		} asDictionary"
	^ string
]

{ #category : #visiting }
GtLOllamaCompletionsGemma4UserMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [
	| content text |

	content := OrderedCollection new.
	text := aDataBlock compositeJsonDataBlock acceptVisitor: self.
	content add: {
		'type' -> 'text'.
		'text' -> (NeoJSONWriter toStringPretty: text first)
		} asDictionary.
	aDataBlock imageDataBlocks do: [ :dataBlock |
		content add: {
			'type' -> 'image_url'.
			'image_url' -> ('data:image/', dataBlock imageType, ';base64,', dataBlock encodedBytes).
			} asDictionary. ].
	^ content asArray.
]

{ #category : #visiting }
GtLOllamaCompletionsGemma4UserMessageVisitor >> visitNode: aUserMessage [

	^ aUserMessage acceptVisitor: self
]
