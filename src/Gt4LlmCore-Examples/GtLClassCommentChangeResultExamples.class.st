Class {
	#name : #GtLClassCommentChangeResultExamples,
	#superclass : #GtLClassChangeResultExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassCommentChangeResultExamples >> basicClassCommentChangeResult [
	<gtExample>
	<return: #GtLClassCommentChangeResult>
	| result originalClass updatedClass |
	originalClass := self objectClassDefinitionDescriptionWithComment:'Old class comment'.
	updatedClass := self objectClassDefinitionDescriptionWithComment: 'New class comment'.
	result := GtLClassCommentChangeResult new
		originalClass: originalClass;
		updatedClass: updatedClass;
		status: 'changed';
		yourself.
		
	self assert: result originalClass currentClassName equals: 'Object'.
	self assert: result originalClass packageName equals: 'Kernel'.
	self assert: result originalClass packageTagName equals: 'Objects'.
	self assert: result updatedClass currentClassName equals: 'Object'.
	self assert: result updatedClass packageName equals: 'Kernel'.
	self assert: result updatedClass packageTagName equals: 'Objects'.
	self assert: result changedClassName equals: 'Object'.
	self assert: result status equals: 'changed'.
	self assert: result oldClassComment equals: 'Old class comment'.
	self assert: result newClassComment equals: 'New class comment'.
	self assertResultIsClass: result.
	self assertResultIsClassCommentChange: result.
	
	^ result
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> classCommentChangeDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock expectedJson |
	
	result := self basicClassCommentChangeResult.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#changedClassName -> 'Object'.
		#status -> 'changed'
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> classCommentChangeResultWithNilOldComment [
	<gtExample>
	<return: #GtLClassCommentChangeResult>
	| result originalClass updatedClass |
	
	originalClass := self objectClassDefinitionDescriptionWithComment: nil.
	updatedClass := self objectClassDefinitionDescriptionWithComment:'First comment' .
	result := GtLClassCommentChangeResult new
		originalClass: originalClass;
		updatedClass: updatedClass;
		status: 'changed'.
		
	self assert: result updatedClass currentClassName equals: 'Object'.
	self assert: result updatedClass packageName equals: 'Kernel'.
	self assert: result updatedClass packageTagName equals: 'Objects'.
	self assert: result oldClassComment isNil.
	self assert: result newClassComment equals: 'First comment'.
	self assertResultIsClass: result.
	self assertResultIsClassCommentChange: result.
	
	^ result
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> classCommentChangeResultWithNilOldCommentDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData expectedJson |
	
	result := self classCommentChangeResultWithNilOldComment.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#changedClassName -> 'Object'.
		#status -> 'changed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> emptyClassCommentChangeDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData expectedJson |
	
	result := self emptyClassCommentChangeResult.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#changedClassName -> 'Object'.
		#status -> 'changed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassCommentChangeResultExamples >> emptyClassCommentChangeResult [
	<gtExample>
	<return: #GtLClassCommentChangeResult>
	| result originalClass updatedClass |
	
	originalClass := self objectClassDefinitionDescriptionWithComment: ''.
	updatedClass := self objectClassDefinitionDescriptionWithComment:'A new comment' .
	result := GtLClassCommentChangeResult new
		originalClass:originalClass;
		updatedClass: updatedClass;
		status: 'changed'.
		
	self assert: result updatedClass currentClassName equals: 'Object'.
	self assert: result updatedClass packageName equals: 'Kernel'.
	self assert: result updatedClass packageTagName equals: 'Objects'.
	self assert: result oldClassComment equals: ''.
	self assert: result newClassComment equals: 'A new comment'.
	self assertResultIsClass: result.
	self assertResultIsClassCommentChange: result.
	
	^ result
]

{ #category : #private }
GtLClassCommentChangeResultExamples >> objectClassDefinitionDescription [
	^ GtLClassDefinitionDescription fromClass: Object
]

{ #category : #private }
GtLClassCommentChangeResultExamples >> objectClassDefinitionDescriptionWithComment: aComment [
	^ (GtLClassDefinitionDescription fromClass: Object)
			comment: aComment
]
