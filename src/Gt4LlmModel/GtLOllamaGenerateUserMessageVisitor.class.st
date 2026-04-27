Class {
	#name : #GtLOllamaGenerateUserMessageVisitor,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #api }
GtLOllamaGenerateUserMessageVisitor >> userMessageWith: aMessage [

	^ aMessage computeContentBlockFromInputModels acceptVisitor: self.
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
GtLOllamaGenerateUserMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [

	^ aDataBlock compositeJsonDataBlock acceptVisitor: self.
]
