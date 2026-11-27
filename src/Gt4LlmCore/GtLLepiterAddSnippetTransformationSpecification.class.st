Class {
	#name : #GtLLepiterAddSnippetTransformationSpecification,
	#superclass : #GtLLepiterSnippetTransformationSpecification,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLLepiterAddSnippetTransformationSpecification class >> refactoringName [
	^ 'Add snippet'
]

{ #category : #accessing }
GtLLepiterAddSnippetTransformationSpecification >> refactoringDescription [
	^ self refactoringName , ' to ' , self pageDescription
]
