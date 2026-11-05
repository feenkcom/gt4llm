Class {
	#name : #GtLTransformationsSchemaExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - basic' }
GtLTransformationsSchemaExamples >> transformationsSchema [
	<gtExample>
	<return: #GtLTransformationsSchema>
	| schema transformationsSchema |
	schema := (Dictionary new)
				at: 'type' put: 'object';
				yourself.
	transformationsSchema := GtLTransformationsSchema new schema: schema.
	self assert: transformationsSchema schema equals: schema.
	^transformationsSchema
]

{ #category : #'examples - views' }
GtLTransformationsSchemaExamples >> transformationsSchemaMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self transformationsSchema
				llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #'examples - serialization' }
GtLTransformationsSchemaExamples >> transformationsSchemaSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expectedJsonData |
	dataBlock := self transformationsSchemaMainDataView
				serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expectedJsonData := (Dictionary new)
				at: 'transformationsSchema'
					put: ((Dictionary new)
							at: 'type' put: 'object';
							yourself);
				yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJsonData.
	^dataBlock
]
