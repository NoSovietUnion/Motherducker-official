; Motherducker MDickie Mini Game
; A small arcade-style game written in BlitzBasic.
; Features: move, collect stars, avoid hazards, score and lives.

AppTitle "Motherducker: MDickie Dash"
Graphics 960, 600, 32, 2
SetBuffer BackBuffer()
SeedRnd MilliSecs()

Const SCREEN_W = 960
Const SCREEN_H = 600
Const PLAYER_W = 28
Const PLAYER_H = 28
Const PLAYER_SPEED = 6

Global px = SCREEN_W / 2
Global py = SCREEN_H - 80
Global score = 0
Global lives = 3
Global gameOver = False
Global gameWon = False
Global gameTicks = 0

Dim starX(49)
Dim starY(49)
Dim starVel(49)
Dim starActive(49)

For i = 0 To 49
  starX(i) = Rnd(SCREEN_W - 80) + 40
  starY(i) = -Rnd(1000) - 20
  starVel(i) = Rnd(4) + 2
  starActive(i) = True
Next

Dim enemyX(9)
Dim enemyY(9)
Dim enemyVel(9)
Dim enemyActive(9)

For i = 0 To 9
  enemyX(i) = Rnd(SCREEN_W - 60) + 30
  enemyY(i) = -Rnd(1200) - 60
  enemyVel(i) = Rnd(5) + 3
  enemyActive(i) = True
Next

Function ResetStar(index)
  starX(index) = Rnd(SCREEN_W - 80) + 40
  starY(index) = -Rnd(200) - 20
  starVel(index) = Rnd(4) + 2
  starActive(index) = True
End Function

Function ResetEnemy(index)
  enemyX(index) = Rnd(SCREEN_W - 60) + 30
  enemyY(index) = -Rnd(1200) - 60
  enemyVel(index) = Rnd(5) + 3
  enemyActive(index) = True
End Function

While Not KeyDown(1)
  Cls

  If Not gameOver And Not gameWon Then
    gameTicks = gameTicks + 1

    ; Movement
    If KeyDown(203) Then px = px - PLAYER_SPEED ; left
    If KeyDown(205) Then px = px + PLAYER_SPEED ; right
    If KeyDown(200) Then py = py - PLAYER_SPEED ; up
    If KeyDown(208) Then py = py + PLAYER_SPEED ; down

    ; Keep inside screen
    If px < 0 Then px = 0
    If px > SCREEN_W - PLAYER_W Then px = SCREEN_W - PLAYER_W
    If py < 0 Then py = 0
    If py > SCREEN_H - PLAYER_H Then py = SCREEN_H - PLAYER_H

    ; Pickups
    For i = 0 To 49
      If starActive(i) Then
        starY(i) = starY(i) + starVel(i)

        If starY(i) > SCREEN_H + 20 Then
          ResetStar(i)
        End If

        If starX(i) > px And starX(i) < px + PLAYER_W And starY(i) > py And starY(i) < py + PLAYER_H Then
          score = score + 10
          ResetStar(i)
        End If
      End If
    Next

    ; Hazards
    For i = 0 To 9
      If enemyActive(i) Then
        enemyY(i) = enemyY(i) + enemyVel(i)

        If enemyY(i) > SCREEN_H + 30 Then
          ResetEnemy(i)
        End If

        If enemyX(i) > px And enemyX(i) < px + PLAYER_W And enemyY(i) > py And enemyY(i) < py + PLAYER_H Then
          lives = lives - 1
          ResetEnemy(i)

          If lives <= 0 Then
            gameOver = True
          End If
        End If
      End If
    Next

    ; Win condition
    If score >= 200 Then
      gameWon = True
    End If
  End If

  ; Draw background
  Color 25, 30, 45
  Rect 0, 0, SCREEN_W, SCREEN_H, True

  ; Draw stars (collectables)
  For i = 0 To 49
    If starActive(i) Then
      Color 120, 240, 210
      Oval starX(i), starY(i), 10, 10, True
    End If
  Next

  ; Draw enemies
  For i = 0 To 9
    If enemyActive(i) Then
      Color 255, 90, 110
      Oval enemyX(i), enemyY(i), 18, 18, True
    End If
  Next

  ; Draw player
  Color 140, 170, 255
  Rect px, py, PLAYER_W, PLAYER_H, True

  ; UI text
  Color 255, 255, 255
  Text 18, 18, "Motherducker: MDickie Dash"
  Text 18, 42, "Score: " + score
  Text 18, 66, "Lives: " + lives

  If gameOver Then
    Color 255, 110, 120
    Text SCREEN_W / 2 - 100, SCREEN_H / 2 - 20, "GAME OVER"
    Text SCREEN_W / 2 - 140, SCREEN_H / 2 + 20, "Press ESC to quit"
  End If

  If gameWon Then
    Color 120, 240, 210
    Text SCREEN_W / 2 - 120, SCREEN_H / 2 - 20, "YOU WIN!"
    Text SCREEN_W / 2 - 170, SCREEN_H / 2 + 20, "Final Score: " + score
  End If

  Flip
Wend

End
