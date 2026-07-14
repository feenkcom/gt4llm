Class {
	#name : #GtLGemStoneProxyObjectPhlowViewExtractor,
	#superclass : #GtLBasicObjectPhlowViewExtractor,
	#category : #'Gt4LlmCore-Phlow'
}

{ #category : #'view creation' }
GtLGemStoneProxyObjectPhlowViewExtractor >> computeLocalPhlowViewOnError: anErrorBlock [
	^ ((GtLObjectPhlowViewExtractor forTargetObject: targetObject)
			viewSelector: viewSelector)
				phlowViewDomainObjectOnError: anErrorBlock
]

{ #category : #'view creation' }
GtLGemStoneProxyObjectPhlowViewExtractor >> computePhlowViewDomainObjectOnError: anErrorBlock [
	| phlowView targetMethod viewMethodClassName viewMethodSourceCode |
	
	(targetObject class canUnderstand: viewSelector asSymbol)
		ifTrue: [ ^ self computeLocalPhlowViewOnError: anErrorBlock].
		
	phlowView := self computeRemotePhlowView.
					
	targetMethod := phlowView definingMethod asGtBareProxyObject.
	viewMethodClassName := targetMethod inClass name.
	viewMethodSourceCode := targetMethod sourceString.
	
	^ GtLRemotePhlowViewDomainObject
			phlowView: phlowView
			viewMethodClassName: viewMethodClassName 
			viewMethodSourceCode: viewMethodSourceCode 
]

{ #category : #'view creation' }
GtLGemStoneProxyObjectPhlowViewExtractor >> computeRemotePhlowView [ 
	^ targetObject 
			remoteViewWithSelector: viewSelector 
			for: GtPhlowView empty 
			inContext:  GtPhlowContext new 
			from: targetObject getLocalProxyInspector
]
