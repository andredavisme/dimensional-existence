async function submitQuiz() {
  const name = document.getElementById('player-name').value.trim();
  if (!name) { alert('Please enter your name first.'); return; }

  let score = 0;
  const total = Object.keys(ANSWERS).length;

  for (const [q, correct] of Object.entries(ANSWERS)) {
    const selected = document.querySelector(`input[name="${q}"]:checked`);
    if (selected && selected.value === correct) score++;
  }

  const pct = Math.round((score / total) * 100);
  document.getElementById('result').textContent = `You scored ${score}/${total} (${pct}%)`;

  // Save to Supabase
  await window.sb.from('quiz_attempts').insert({
    player_name: name,
    quiz_id: QUIZ_ID,
    score,
    total_questions: total,
    pct_score: pct
  });
}
