Class {
	#name : #GtLObjectPhlowViewExtractor,
	#superclass : #GtLBasicObjectPhlowViewExtractor,
	#category : #'Gt4LlmCore-Phlow'
}

{ #category : #'view creation' }
GtLObjectPhlowViewExtractor >> computePhlowView [ 
	^ GtPhlowView empty
			on: targetObject
			perform: viewSelector
			withContext: GtPhlowContext new
]

{ #category : #'view creation' }
GtLObjectPhlowViewExtractor >> computePhlowViewDomainObjectOnError: anErrorBlock [
	| phlowView targetMethod viewMethodClassName viewMethodSourceCode |

	(targetObject class lookupSelector: viewSelector) ifNil: [ 
		^ anErrorBlock value: (GtLMissingDomainObject new objectName: viewSelector) ].
		
	phlowView := self computePhlowView .
					
	targetMethod := targetObject class lookupSelector: viewSelector.
	viewMethodClassName := targetMethod methodClass name.
	viewMethodSourceCode := targetMethod sourceCode.
	
	^ GtLPhlowViewDomainObject
			phlowView: phlowView
			viewMethodClassName: viewMethodClassName 
			viewMethodSourceCode: viewMethodSourceCode 
]
