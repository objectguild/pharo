"
I am able to rename a slot in a trait, so it does not conflict with the ones in the class.
Also I rename all the uses of this slot in my methods.
I implement the #>> operator in traits.
"
Class {
	#name : #TaRenameSlot,
	#superclass : #TaSingleComposition,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'TraitsV2-Compositions'
}

{ #category : #'instance creation' }
TaRenameSlot class >> from:oldName to: newName on: aTrait [
	^ self new 
		oldName: oldName;
		newName: newName;
		inner: aTrait;
		yourself.
]

{ #category : #copying }
TaRenameSlot >> copyTraitExpression [
	^ self class from: oldName to: newName on: inner
]

{ #category : #accessing }
TaRenameSlot >> newName [
	^ newName
]

{ #category : #accessing }
TaRenameSlot >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
TaRenameSlot >> oldName [
	^ oldName
]

{ #category : #accessing }
TaRenameSlot >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
TaRenameSlot >> slots [
	^ inner slots
		collect: [ :e | 
			| slot |
			slot := e asSlot.
			slot name = oldName
				ifTrue: [ slot name: newName ].
			slot ]
]

{ #category : #accessing }
TaRenameSlot >> sourceCodeAt: aSelector [
	| originalSourceCode parseTree |
	originalSourceCode := super sourceCodeAt: aSelector.

	parseTree := RBParser parseMethod: originalSourceCode.

	^ (RBParseTreeRewriter new
		replace: oldName asString with: newName asString;
		executeTree: parseTree;
		tree) formattedCode
]
