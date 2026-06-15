Class {
	#name : #GtLGemStoneProxyObjectPhlowViewExtractor,
	#superclass : #GtLBasicObjectPhlowViewExtractor,
	#category : #'Gt4LlmCore-Phlow'
}

{ #category : #'view creation' }
GtLGemStoneProxyObjectPhlowViewExtractor >> computePhlowView [ 
	^ targetObject 
			remoteViewWithSelector: viewSelector 
			for: GtPhlowView empty 
			inContext:  GtPhlowContext new 
			from: targetObject getLocalProxyInspector
]

{ #category : #'view creation' }
GtLGemStoneProxyObjectPhlowViewExtractor >> computePhlowViewDomainObjectOnError: anErrorBlock [
	| phlowView targetMethod viewMethodClassName viewMethodSourceCode |
	
	phlowView := self computePhlowView .
					
	targetMethod := phlowView definingMethod asGtBareProxyObject.
	viewMethodClassName := targetMethod inClass name.
	viewMethodSourceCode := targetMethod sourceString.
	
	^ GtLRemotePhlowViewDomainObject
			phlowView: phlowView
			viewMethodClassName: viewMethodClassName 
			viewMethodSourceCode: viewMethodSourceCode 
]
