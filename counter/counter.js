// Page view counter — uses Supabase RPC to atomically increment
(async () => {
  if (!window.sb) return;
  const page = window.location.pathname;

  // Call the increment function
  await window.sb.rpc('increment_page_view', { p_page: page });

  // Fetch updated count
  const { data: row, error } = await window.sb
    .from('page_views')
    .select('views')
    .eq('page', page)
    .single();

  const el = document.getElementById('view-count');
  if (el) el.textContent = row ? row.views.toLocaleString() : '—';
})();
