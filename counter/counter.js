// Page view counter — increments on every page load
(async () => {
  const page = window.location.pathname;
  const { data, error } = await window.sb
    .from('page_views')
    .upsert({ page, views: 1 }, { onConflict: 'page', ignoreDuplicates: false })
    .select();

  // Fetch updated count
  const { data: row } = await window.sb
    .from('page_views')
    .select('views')
    .eq('page', page)
    .single();

  const el = document.getElementById('view-count');
  if (el && row) el.textContent = row.views.toLocaleString();
})();
